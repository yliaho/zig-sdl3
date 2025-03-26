const C = @import("c.zig").C;
const std = @import("std");
const surface = @import("surface.zig");

/// A callback that is invoked when a tray entry is selected.
///
/// ## Function Parameters
/// * `user_data`: An optional pointer to pass extra data to the callback when it will be invoked.
/// * `entry`: The tray entry that was selected.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const Callback = *const fn (user_date: ?*anyopaque, entry: [*c]C.SDL_TrayEntry) callconv(.C) void;

/// An opaque handle representing an entry on a system tray object.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Entry = struct {
    value: *C.SDL_TrayEntry,

    /// Simulate a click on a tray entry.
    ///
    /// ## Function Parameters
    /// * `self`: The entry to activate.
    ///
    /// ## Thread Safety
    /// This function should be called on the thread that created the tray.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn click(
        self: Entry,
    ) void {
        C.SDL_ClickTrayEntry(self.value);
    }
};

/// Flags that control the creation of system tray entries.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const EntryFlags = struct {
    /// Type of entry.
    entry: union(EntryType) {
        /// Make the entry a simple button.
        button: void,
        /// Make the entry a checkbox, value indicates if checked.
        checkbox: bool,
        /// Prepare the entry to have a submenu.
        submenu: void,
    },
    /// Make the entry disabled.
    disabled: bool = false,
};

/// An entry type for a system tray.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const EntryType = enum(C.SDL_TrayEntryFlags) {
    /// Make the entry a simple button.
    button = C.SDL_TRAYENTRY_BUTTON,
    /// Make the entry a checkbox.
    checkbox = C.SDL_TRAYENTRY_CHECKBOX,
    /// Prepare the entry to have a submenu.
    submenu = C.SDL_TRAYENTRY_SUBMENU,
};

/// An opaque handle representing a menu/submenu on a system tray object.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Menu = struct {
    value: *C.SDL_TrayMenu,
};

/// An opaque handle representing a toplevel system tray object.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Tray = struct {
    value: *C.SDL_Tray,

    /// Create a menu for a system tray.
    ///
    /// ## Function Parameters
    /// * `self`: The tray to bind the menu to.
    ///
    /// ## Return Value
    /// Returns the newly created menu.
    ///
    /// ## Remarks
    /// This should be called at most once per tray icon.
    ///
    /// This function does the same thing as `tray.Tray.createMenu()`, except that it takes a `tray.Tray` instead of a `tray.Entry`.
    ///
    /// A menu does not need to be destroyed; it will be destroyed with the tray.
    ///
    /// ## Thread Safety
    /// This function should be called on the thread that created the tray.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createMenu(
        self: Tray,
    ) Menu {
        return .{
            .value = C.SDL_CreateTrayMenu(self.value),
        };
    }

    /// Create an icon to be placed in the operating system's tray, or equivalent.
    ///
    /// ## Function Parameters
    /// * `icon`: A surface to be used as icon. May be `null`.
    /// * `tooltip`: A tooltip to be displayed when the mouse hovers the icon in UTF-8 encoding. Not supported on all platforms. May be `null`
    ///
    /// ## Return Value
    /// Returns the newly created system tray icon.
    ///
    /// ## Remarks
    /// Many platforms advise not using a system tray unless persistence is a necessary feature.
    /// Avoid needlessly creating a tray icon, as the user may feel like it clutters their interface.
    ///
    /// Using tray icons require the video subsystem.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## Code Examples
    /// TODO!!!
    pub fn init(
        icon: ?surface.Surface,
        tooltip: ?[:0]const u8,
    ) Tray {
        return .{ .value = C.SDL_CreateTray(
            if (icon) |val| val.value else null,
            if (tooltip) |val| val.ptr else null,
        ).? };
    }

    /// Updates the system tray icon's tooltip.
    ///
    /// ## Function Parameters
    /// * `self`: The tray icon to be updated.
    /// * `tooltip`: The new tooltip in UTF-8 encoding. May be `null`.
    ///
    /// ## Thread Safety
    /// This function should be called on the thread that created the tray.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn setTooltip(
        self: Tray,
        tooltip: ?[:0]const u8,
    ) void {
        C.SDL_SetTrayTooltip(self.value, if (tooltip) |val| val.ptr else null);
    }
};

/// Update the trays.
///
/// ## Remarks
/// This is called automatically by the event loop and is only needed if you're using trays but aren't handling SDL events.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn update() void {
    C.SDL_UpdateTrays();
}

// Tray testing.
test "Tray" {
    // Entry.click
    // Tray.init
    // Tray.createMenu
    // Entry.createSubmenu
    // setTooltip
    // update
}
