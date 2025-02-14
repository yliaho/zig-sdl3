const C = @import("c.zig").C;
const std = @import("std");

/// Functionality to query the current SDL version, both as headers the app was compiled against, and a library the app is linked to.
pub const Version = packed struct {
    value: c_int,
    /// This is the version number macro for the current SDL version.
    ///
    /// This field is available since SDL 3.2.0.
    pub const compiled_against = Version{ .value = C.SDL_VERSION };

    /// A string describing the source at a particular point in development.
    ///
    /// This string is often generated from revision control's state at build time.
    ///
    /// This string can be quite complex and does not follow any standard.
    /// For example, it might be something like "SDL-prerelease-3.1.1-47-gf687e0732".
    /// It might also be user-defined at build time, so it's best to treat it as a clue in debugging forensics and not something the app will parse in any way.
    ///
    /// This field is available since SDL 3.2.0.
    // pub const revision = C.SDL_REVISION; // This should exist but does not?

    /// Check if the SDL version is at least greater than the given one.
    ///
    /// * `major` - Major version to compare against.
    /// * `minor` - Minor version to compare against.
    /// * `micro` - Micro version to compare against.
    pub fn atLeast(
        major: u32,
        minor: u32,
        micro: u32,
    ) bool {
        const ret = C.SDL_VERSION_ATLEAST(
            @as(c_int, @intCast(major)),
            @as(c_int, @intCast(minor)),
            @as(c_int, @intCast(micro)),
        );
        return ret;
    }

    /// Get the version of SDL that is linked against your program.
    ///
    /// Returns the version of the linked library.
    ///
    /// If you are linking to SDL dynamically, then it is possible that the current version will be different than the version you compiled against.
    /// This function returns the current version, while `Version.compiled_version` is the version you compiled with.
    ///
    /// This function may be called safely at any time, even before `init.init()`.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn get() Version {
        const ret = C.SDL_GetVersion();
        return Version{ .value = ret };
    }

    /// Extracts the major version from a version number.
    ///
    /// * `self`: The version number.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn getMajor(
        self: Version,
    ) u32 {
        const ret = C.SDL_VERSIONNUM_MAJOR(
            self.value,
        );
        return @intCast(ret);
    }

    /// Extracts the minor version from a version number.
    ///
    /// * `self`: The version number.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn getMinor(
        self: Version,
    ) u32 {
        const ret = C.SDL_VERSIONNUM_MINOR(
            self.value,
        );
        return @intCast(ret);
    }

    /// Extracts the micro version from a version number.
    ///
    /// * `self`: The version number.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn getMicro(
        self: Version,
    ) u32 {
        const ret = C.SDL_VERSIONNUM_MICRO(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the code revision of SDL that is linked against your program.
    ///
    /// Returns an arbitrary string, uniquely identifying the exact revision of the SDL library in use, or `null` possibly.
    ///
    /// This value is the revision of the code you are linked with and may be different from the code you are compiling with,
    /// which is found in the constant `Version.compiled_revision`.
    ///
    /// The revision is arbitrary string (a hash value) uniquely identifying the exact revision of the SDL library in use,
    /// and is only useful in comparing against other revisions. It is NOT an incrementing number.
    ///
    /// If SDL wasn't built from a git repository with the appropriate tools, this will return an empty string.
    ///
    /// You shouldn't use this function for anything but logging it for debugging purposes. The string is not intended to be reliable in any way.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn getRevision() ?[]const u8 {
        const ret = C.SDL_GetRevision();
        const converted_ret = std.mem.span(ret);
        if (std.mem.eql(u8, converted_ret, ""))
            return null;
        return converted_ret;
    }

    /// Turns the version numbers into a numeric value.
    ///
    /// * `major` - The major version number.
    /// * `minor` - The minor version number.
    /// * `micro` - The micro version number.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn make(
        major: u32,
        minor: u32,
        micro: u32,
    ) Version {
        const ret = C.SDL_VERSIONNUM(
            @as(c_int, @intCast(major)),
            @as(c_int, @intCast(minor)),
            @as(c_int, @intCast(micro)),
        );
        return Version{ .value = ret };
    }
};

// Test version functionality.
test "Version" {
    try std.testing.expectEqual(true, Version.getRevision() != null);
    try std.testing.expectEqual(true, Version.atLeast(3, 0, 1));
    try std.testing.expectEqual(false, Version.atLeast(4, 0, 0));
    try std.testing.expectEqual(Version.compiled_against, Version.get());

    const sample_version = Version{ .value = 3_002_001 };
    try std.testing.expectEqual(sample_version, Version.make(3, 2, 1));

    try std.testing.expectEqual(3, sample_version.getMajor());
    try std.testing.expectEqual(2, sample_version.getMinor());
    try std.testing.expectEqual(1, sample_version.getMicro());
}
