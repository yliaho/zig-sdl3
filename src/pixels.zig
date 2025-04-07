// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Pixel type.
pub const Type = enum(c_uint) {
    Index1 = C.SDL_PIXELTYPE_INDEX1,
    Index2 = C.SDL_PIXELTYPE_INDEX2,
    Index4 = C.SDL_PIXELTYPE_INDEX4,
    Index8 = C.SDL_PIXELTYPE_INDEX8,
    Packed8 = C.SDL_PIXELTYPE_PACKED8,
    Packed16 = C.SDL_PIXELTYPE_PACKED16,
    Packed32 = C.SDL_PIXELTYPE_PACKED32,
    ArrayU8 = C.SDL_PIXELTYPE_ARRAYU8,
    ArrayU16 = C.SDL_PIXELTYPE_ARRAYU16,
    ArrayU32 = C.SDL_PIXELTYPE_ARRAYU32,
    ArrayF16 = C.SDL_PIXELTYPE_ARRAYF16,
    ArrayF32 = C.SDL_PIXELTYPE_ARRAYF32,
};

/// Bitmap pixel order, high bit -> low bit.
pub const IndexOrder = enum(c_uint) {
    None = C.SDL_BITMAPORDER_NONE,
    HighToLow = C.SDL_BITMAPORDER_4321,
    LowToHigh = C.SDL_BITMAPORDER_1234,
};

/// Packed component order, high bit -> low bit.
pub const PackedOrder = enum(c_uint) {
    None = C.SDL_PACKEDORDER_NONE,
    Xrgb = C.SDL_PACKEDORDER_XRGB,
    Rgbx = C.SDL_PACKEDORDER_RGBX,
    Argb = C.SDL_PACKEDORDER_ARGB,
    Rgba = C.SDL_PACKEDORDER_RGBA,
    Xbgr = C.SDL_PACKEDORDER_XBGR,
    Bgrx = C.SDL_PACKEDORDER_BGRX,
    Abgr = C.SDL_PACKEDORDER_ABGR,
    Bgra = C.SDL_PACKEDORDER_BGRA,
};

/// Array component order, low byte -> high byte.
pub const ArrayOrder = enum(c_uint) {
    None = C.SDL_ARRAYORDER_NONE,
    Rgb = C.SDL_ARRAYORDER_RGB,
    Rgba = C.SDL_ARRAYORDER_RGBA,
    Argb = C.SDL_ARRAYORDER_ARGB,
    Bgr = C.SDL_ARRAYORDER_BGR,
    Bgra = C.SDL_ARRAYORDER_BGRA,
    Abgr = C.SDL_ARRAYORDER_ABGR,
};

/// Packed component layout.
pub const Layout = enum(c_uint) {
    None = C.SDL_PACKEDLAYOUT_NONE,
    Bit_3_3_2 = C.SDL_PACKEDLAYOUT_332,
    Bit_4_4_4_4 = C.SDL_PACKEDLAYOUT_4444,
    Bit_1_5_5_5 = C.SDL_PACKEDLAYOUT_1555,
    Bit_5_5_5_1 = C.SDL_PACKEDLAYOUT_5551,
    Bit_5_6_5 = C.SDL_PACKEDLAYOUT_565,
    Bit_8_8_8_8 = C.SDL_PACKEDLAYOUT_8888,
    Bit_2_10_10_10 = C.SDL_PACKEDLAYOUT_2101010,
    Bit_10_10_10_2 = C.SDL_PACKEDLAYOUT_1010102,
};

/// Colorspace color type.
pub const ColorType = enum(c_uint) {
    Rgb = C.SDL_COLOR_TYPE_RGB,
    Ycbcr = C.SDL_COLOR_TYPE_YCBCR,
};

/// Colorspace color range, as described by https://www.itu.int/rec/R-REC-BT.2100-2-201807-I/en.
pub const ColorRange = enum(c_uint) {
    Limited = C.SDL_COLOR_RANGE_LIMITED,
    Full = C.SDL_COLOR_RANGE_FULL,
};

/// Colorspace color primaries, as described by https://www.itu.int/rec/T-REC-H.273-201612-S/en.
pub const ColorPrimaries = enum(c_uint) {
    /// ITU-R BT.709-6.
    BT709 = C.SDL_COLOR_PRIMARIES_BT709,
    UNSPECIFIED = C.SDL_COLOR_PRIMARIES_UNSPECIFIED,
    /// ITU-R BT.470-6 System M.
    BT470M = C.SDL_COLOR_PRIMARIES_BT470M,
    /// ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625.
    BT470BG = C.SDL_COLOR_PRIMARIES_BT470BG,
    /// ITU-R BT.601-7 525, SMPTE 170M.
    BT601 = C.SDL_COLOR_PRIMARIES_BT601,
    /// SMPTE 240M, functionally the same as SDL_COLOR_PRIMARIES_BT601.
    SMPTE240 = C.SDL_COLOR_PRIMARIES_SMPTE240,
    /// Generic film (color filters using Illuminant C).
    GENERIC_FILM = C.SDL_COLOR_PRIMARIES_GENERIC_FILM,
    /// ITU-R BT.2020-2 / ITU-R BT.2100-0
    BT2020 = C.SDL_COLOR_PRIMARIES_BT2020,
    /// SMPTE ST 428-1SMPTE ST 428-1.
    XYZ = C.SDL_COLOR_PRIMARIES_XYZ,
    /// SMPTE RP 431-2.
    SMPTE431 = C.SDL_COLOR_PRIMARIES_SMPTE431,
    /// SMPTE EG 432-1 / DCI P3.
    SMPTE432 = C.SDL_COLOR_PRIMARIES_SMPTE432,
    /// EBU Tech. 3213-E.
    EBU3213 = C.SDL_COLOR_PRIMARIES_EBU3213,
    Custom = C.SDL_COLOR_PRIMARIES_CUSTOM,
};

/// Colorspace transfer characteristics.
pub const TransferCharacteristics = enum(c_uint) {
    /// Rec. ITU-R BT.709-6 / ITU-R BT1361.
    BT709 = C.SDL_TRANSFER_CHARACTERISTICS_BT709,
    Unspecified = C.SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED,
    /// ITU-R BT.470-6 System M / ITU-R BT1700 625 PAL & SECAM.
    Gamma22 = C.SDL_TRANSFER_CHARACTERISTICS_GAMMA22,
    /// ITU-R BT.470-6 System B, G.
    Gamma28 = C.SDL_TRANSFER_CHARACTERISTICS_GAMMA28,
    /// SMPTE ST 170M / ITU-R BT.601-7 525 or 625.
    BT601 = C.SDL_TRANSFER_CHARACTERISTICS_BT601,
    /// SMPTE ST 240M.
    SMPTE240 = C.SDL_TRANSFER_CHARACTERISTICS_SMPTE240,
    Linear = C.SDL_TRANSFER_CHARACTERISTICS_LINEAR,
    Log100 = C.SDL_TRANSFER_CHARACTERISTICS_LOG100,
    Sqrt10 = C.SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10,
    /// IEC 61966-2-4.
    IEC61966 = C.SDL_TRANSFER_CHARACTERISTICS_IEC61966,
    /// ITU-R BT1361 Extended Colour Gamut.
    BT1361 = C.SDL_TRANSFER_CHARACTERISTICS_BT1361,
    /// IEC 61966-2-1 (sRGB or sYCC).
    Srgb = C.SDL_TRANSFER_CHARACTERISTICS_SRGB,
    /// ITU-R BT2020 for 10-bit system.
    BT2020_10Bit = C.SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT,
    /// ITU-R BT2020 for 12-bit system.
    Bt2020_12Bit = C.SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT,
    /// SMPTE ST 2084 for 10-, 12-, 14- and 16-bit system.
    PQ = C.SDL_TRANSFER_CHARACTERISTICS_PQ,
    /// SMPTE ST 428-1.
    SMPTE428 = C.SDL_TRANSFER_CHARACTERISTICS_SMPTE428,
    /// ARIB STD-B67, known as hybrid log-gamma (HLG).
    HLG = C.SDL_TRANSFER_CHARACTERISTICS_HLG,
    Custom = C.SDL_TRANSFER_CHARACTERISTICS_CUSTOM,
};

/// Colorspace matrix coefficients.
pub const MatrixCoefficients = enum(c_uint) {
    Identity = C.SDL_MATRIX_COEFFICIENTS_IDENTITY,
    /// ITU-R BT.709-6.
    BT709 = C.SDL_MATRIX_COEFFICIENTS_BT709,
    Unspecified = C.SDL_MATRIX_COEFFICIENTS_UNSPECIFIED,
    /// US FCC Title 47.
    FCC = C.SDL_MATRIX_COEFFICIENTS_FCC,
    /// ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625, functionally the same as SDL_MATRIX_COEFFICIENTS_BT601.
    BT470BG = C.SDL_MATRIX_COEFFICIENTS_BT470BG,
    /// ITU-R BT.601-7 525.
    BT601 = C.SDL_MATRIX_COEFFICIENTS_BT601,
    /// SMPTE 240M.
    SMPTE240 = C.SDL_MATRIX_COEFFICIENTS_SMPTE240,
    YCGCO = C.SDL_MATRIX_COEFFICIENTS_YCGCO,
    /// ITU-R BT.2020-2 non-constant luminance.
    BT2020_NCL = C.SDL_MATRIX_COEFFICIENTS_BT2020_NCL,
    /// ITU-R BT.2020-2 constant luminance.
    BT2020_CL = C.SDL_MATRIX_COEFFICIENTS_BT2020_CL,
    SMPTE2085 = C.SDL_MATRIX_COEFFICIENTS_SMPTE2085,
    ChromaDerivedNCL = C.SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL,
    ChromaDerivedCL = C.SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL,
    /// ITU-R BT.2100-0 ICTCP.
    ICTCP = C.SDL_MATRIX_COEFFICIENTS_ICTCP,
    Custom = C.SDL_MATRIX_COEFFICIENTS_CUSTOM,
};

/// Colorspace chroma sample location.
pub const ChromaLocation = enum(c_uint) {
    /// In MPEG-2, MPEG-4, and AVC, Cb and Cr are taken on midpoint of the left-edge of the 2x2 square. In other words, they have the same horizontal location as the top-left pixel, but is shifted one-half pixel down vertically.
    Left = C.SDL_CHROMA_LOCATION_LEFT,
    /// In JPEG/JFIF, H.261, and MPEG-1, Cb and Cr are taken at the center of the 2x2 square. In other words, they are offset one-half pixel to the right and one-half pixel down compared to the top-left pixel.
    Center = C.SDL_CHROMA_LOCATION_CENTER,
    /// In HEVC for BT.2020 and BT.2100 content (in particular on Blu-rays), Cb and Cr are sampled at the same location as the group's top-left Y pixel (co-sited, co-located).
    TopLeft = C.SDL_CHROMA_LOCATION_TOPLEFT,
};

/// Pixel format.
pub const Format = struct {
    value: c_uint,
    pub const Index_1_lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX1LSB };
    pub const index_1_msb = Format{ .value = C.SDL_PIXELFORMAT_INDEX1MSB };
    pub const index_2_lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX2LSB };
    pub const index_2_msb = Format{ .value = C.SDL_PIXELFORMAT_INDEX2MSB };
    pub const index_4_lsb = Format{ .value = C.SDL_PIXELFORMAT_INDEX4LSB };
    pub const index_4_msb = Format{ .value = C.SDL_PIXELFORMAT_INDEX4MSB };
    pub const index_8 = Format{ .value = C.SDL_PIXELFORMAT_INDEX8 };
    pub const packed_rgb_3_3_2 = Format{ .value = C.SDL_PIXELFORMAT_RGB332 };
    pub const packed_xrgb_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_XRGB4444 };
    pub const packed_xbgr_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_XBGR4444 };
    pub const packed_xrgb_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_XRGB1555 };
    pub const packed_xbgr_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_XBGR1555 };
    pub const packed_argb_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_ARGB4444 };
    pub const packed_rgba_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_RGBA4444 };
    pub const packed_abgr_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_ABGR4444 };
    pub const packed_bgra_4_4_4_4 = Format{ .value = C.SDL_PIXELFORMAT_BGRA4444 };
    pub const packed_argb_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_ARGB1555 };
    pub const packed_rgba_5_5_5_1 = Format{ .value = C.SDL_PIXELFORMAT_RGBA5551 };
    pub const packed_abgr_1_5_5_5 = Format{ .value = C.SDL_PIXELFORMAT_ABGR1555 };
    pub const packed_bgra_5_5_5_1 = Format{ .value = C.SDL_PIXELFORMAT_BGRA5551 };
    pub const packed_rgb_5_6_5 = Format{ .value = C.SDL_PIXELFORMAT_RGB565 };
    pub const packed_bgr_5_6_5 = Format{ .value = C.SDL_PIXELFORMAT_BGR565 };
    pub const arr_rgb_24 = Format{ .value = C.SDL_PIXELFORMAT_RGB24 };
    pub const arr_bgr_24 = Format{ .value = C.SDL_PIXELFORMAT_BGR24 };
    pub const packed_xrgb_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_XRGB8888 };
    pub const packed_rgbx_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_RGBX8888 };
    pub const packed_xbgr_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_XBGR8888 };
    pub const packed_bgrx_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_BGRX8888 };
    pub const packed_argb_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_ARGB8888 };
    pub const packed_rgba_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_RGBA8888 };
    pub const packed_abgr_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_ABGR8888 };
    pub const packed_bgra_8_8_8_8 = Format{ .value = C.SDL_PIXELFORMAT_BGRA8888 };
    pub const packed_xrgb_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_XRGB2101010 };
    pub const packed_xbgr_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_XBGR2101010 };
    pub const packed_argb_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_ARGB2101010 };
    pub const packed_abgr_2_10_10_10 = Format{ .value = C.SDL_PIXELFORMAT_ABGR2101010 };
    pub const array_rgb_48 = Format{ .value = C.SDL_PIXELFORMAT_RGB48 };
    pub const array_bgr_48 = Format{ .value = C.SDL_PIXELFORMAT_BGR48 };
    pub const array_rgba_64 = Format{ .value = C.SDL_PIXELFORMAT_RGBA64 };
    pub const array_argb_64 = Format{ .value = C.SDL_PIXELFORMAT_ARGB64 };
    pub const array_bgra_64 = Format{ .value = C.SDL_PIXELFORMAT_BGRA64 };
    pub const array_abgr_64 = Format{ .value = C.SDL_PIXELFORMAT_ABGR64 };
    pub const array_rgb_48_float = Format{ .value = C.SDL_PIXELFORMAT_RGB48_FLOAT };
    pub const array_bgr_48_float = Format{ .value = C.SDL_PIXELFORMAT_BGR48_FLOAT };
    pub const array_rgba_64_float = Format{ .value = C.SDL_PIXELFORMAT_RGBA64_FLOAT };
    pub const array_argb_64_float = Format{ .value = C.SDL_PIXELFORMAT_ARGB64_FLOAT };
    pub const array_bgra_64_float = Format{ .value = C.SDL_PIXELFORMAT_BGRA64_FLOAT };
    pub const array_abgr_64_float = Format{ .value = C.SDL_PIXELFORMAT_ABGR64_FLOAT };
    pub const fourcc_yv12 = Format{ .value = C.SDL_PIXELFORMAT_YV12 };
    pub const fourcc_iyuv = Format{ .value = C.SDL_PIXELFORMAT_IYUV };
    pub const fourcc_yuy2 = Format{ .value = C.SDL_PIXELFORMAT_YUY2 };
    pub const fourcc_uyvy = Format{ .value = C.SDL_PIXELFORMAT_UYVY };
    pub const fourcc_yvyu = Format{ .value = C.SDL_PIXELFORMAT_YVYU };
    pub const fourcc_nv12 = Format{ .value = C.SDL_PIXELFORMAT_NV12 };
    pub const fourcc_nv21 = Format{ .value = C.SDL_PIXELFORMAT_NV21 };
    pub const fourcc_p010 = Format{ .value = C.SDL_PIXELFORMAT_P010 };
    pub const fourcc_oes = Format{ .value = C.SDL_PIXELFORMAT_EXTERNAL_OES };
    pub const array_rgba_32 = Format{ .value = C.SDL_PIXELFORMAT_RGBA32 };
    pub const array_argb_32 = Format{ .value = C.SDL_PIXELFORMAT_ARGB32 };
    pub const array_bgra_32 = Format{ .value = C.SDL_PIXELFORMAT_BGRA32 };
    pub const array_abgr_32 = Format{ .value = C.SDL_PIXELFORMAT_ABGR32 };
    pub const array_rgbx_32 = Format{ .value = C.SDL_PIXELFORMAT_RGBX32 };
    pub const array_xrgb_32 = Format{ .value = C.SDL_PIXELFORMAT_XRGB32 };
    pub const array_bgrx_32 = Format{ .value = C.SDL_PIXELFORMAT_BGRX32 };
    pub const array_xbgr_32 = Format{ .value = C.SDL_PIXELFORMAT_XBGR32 };

    /// Define a format using 4 characters (Ex: YV12).
    pub fn define4CC(
        a: u8,
        b: u8,
        c: u8,
        d: u8,
    ) Format {
        const ret = C.SDL_DEFINE_PIXELFOURCC(
            @intCast(a),
            @intCast(b),
            @intCast(c),
            @intCast(d),
        );
        return Format{ .value = ret };
    }

    /// Define a pixel format.
    pub fn define(
        pixel_type: Type,
        order: OrderType(pixel_type),
        layout: Layout,
        bits: u8,
        bytes: u8,
    ) Format {
        const ret = C.SDL_DEFINE_PIXELFORMAT(
            @intFromEnum(pixel_type),
            @intFromEnum(order),
            @intFromEnum(layout),
            @intCast(bits),
            @intCast(bytes),
        );
        return Format{ .value = ret };
    }

    /// If format was created by `define` rather than `define4CC`.
    pub fn getFlag(
        self: Format,
    ) bool {
        const ret = C.SDL_PIXELFLAG(
            self.value,
        );
        return ret != 0;
    }

    /// Get the type component of the format.
    pub fn getType(
        self: Format,
    ) ?Type {
        const ret = C.SDL_PIXELTYPE(
            self.value,
        );
        if (ret == C.SDL_PIXELTYPE_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the order component of the format.
    pub fn getOrder(
        self: Format,
    ) c_int {
        const ret = C.SDL_PIXELORDER(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the typed order component of the format. Do not run this on formats with an invalid type!
    pub fn getOrderTyped(
        self: Format,
    ) OrderType(self.getType().?) {
        const ret = C.SDL_PIXELORDER(
            self.value,
        );
        return @enumFromInt(ret);
    }

    /// Get the layout component of the format.
    pub fn getLayout(
        self: Format,
    ) Layout {
        const ret = C.SDL_PACKEDLAYOUT(
            self.value,
        );
        return @enumFromInt(ret);
    }

    /// Get the bits per pixel of the format.
    pub fn getBitsPerPixel(
        self: Format,
    ) u8 {
        const ret = C.SDL_BITSPERPIXEL(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the bytes per pixel of the format.
    pub fn getBytesPerPixel(
        self: Format,
    ) u8 {
        const ret = C.SDL_BYTESPERPIXEL(
            self.value,
        );
        return @intCast(ret);
    }

    /// If the format is indexed.
    pub fn isIndexed(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_INDEXED(
            self.value,
        );
        return ret;
    }

    /// If the format is packed.
    pub fn isPacked(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_PACKED(
            self.value,
        );
        return ret;
    }

    /// If the format is array.
    pub fn isArray(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_ARRAY(
            self.value,
        );
        return ret;
    }

    /// If the format has alpha.
    pub fn hasAlpha(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_ALPHA(
            self.value,
        );
        return ret;
    }

    /// If the format is 10-bit.
    pub fn is10Bit(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_10BIT(
            self.value,
        );
        return ret;
    }

    /// If the format is floating point.
    pub fn isFloat(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_FLOAT(
            self.value,
        );
        return ret;
    }

    /// If the format is 4CC.
    pub fn is4CC(
        self: Format,
    ) bool {
        const ret = C.SDL_ISPIXELFORMAT_FOURCC(
            self.value,
        );
        return ret;
    }

    /// Get the human readable name of a pixel format.
    pub fn getName(
        self: Format,
    ) ?[:0]const u8 {
        const ret = C.SDL_GetPixelFormatName(
            self.value,
        );
        const converted_ret = std.mem.span(ret);
        if (std.mem.eql(u8, converted_ret, "SDL_PIXELFORMAT_UNKNOWN"))
            return null;
        return converted_ret;
    }

    /// Convert one of the enumerated pixel formats to a bpp value and RGBA masks.
    pub fn getMasks(
        self: Format,
    ) !struct { bpp: u8, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32 } {
        var bpp: c_int = undefined;
        var r_mask: u32 = undefined;
        var g_mask: u32 = undefined;
        var b_mask: u32 = undefined;
        var a_mask: u32 = undefined;
        const ret = C.SDL_GetMasksForPixelFormat(
            self.value,
            &bpp,
            &r_mask,
            &g_mask,
            &b_mask,
            &a_mask,
        );
        if (ret == false)
            return null;
        return .{ .bpp = @intCast(bpp), .r_mask = r_mask, .g_mask = g_mask, .b_mask = b_mask, .a_mask = a_mask };
    }

    /// Convert a bpp value and RGBA masks to an enumerated pixel format.
    pub fn fromMasks(
        bpp: u8,
        r_mask: u32,
        g_mask: u32,
        b_mask: u32,
        a_mask: u32,
    ) ?Format {
        const ret = C.SDL_GetPixelFormatForMasks(
            @intCast(bpp),
            @intCast(r_mask),
            @intCast(g_mask),
            @intCast(b_mask),
            @intCast(a_mask),
        );
        if (ret == C.SDL_PIXELFORMAT_UNKNOWN)
            return null;
        return Format{ .value = ret };
    }

    /// Create an SDL_PixelFormatDetails structure corresponding to a pixel format.
    pub fn getDetails(
        self: Format,
    ) !FormatDetails {
        const ret = C.SDL_GetPixelFormatDetails(
            self.value,
        );
        if (ret == null)
            return null;
        return FormatDetails.fromSdl(ret.*);
    }
};

/// A set of indexed colors representing a palette.
pub const Palette = struct {
    value: *C.SDL_Palette,

    /// Create a palette structure with the specified number of color entries.
    pub fn init(
        num_colors: u32,
    ) !Palette {
        const ret = C.SDL_CreatePalette(
            @intCast(num_colors),
        );
        if (ret == null)
            return null;
        return Palette{ .value = ret };
    }

    /// Set a range of colors in a palette.
    pub fn setColors(
        self: Palette,
        colors: []const Color,
        first_color: usize,
    ) !void {
        const ret = C.SDL_SetPaletteColors(
            self.value,
            colors.ptr,
            @intCast(first_color),
            @intCast(colors.len),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Free a palette created earlier.
    pub fn deinit(
        self: Palette,
    ) void {
        const ret = C.SDL_DestroyPalette(
            self.value,
        );
        _ = ret;
    }
};

/// Colorspace definitions.
pub const Colorspace = struct {
    value: u32,
    /// sRGB is a gamma corrected colorspace, and the default colorspace for SDL rendering and 8-bit RGB surfaces.
    pub const Srgb = Colorspace{ .value = C.SDL_COLORSPACE_SRGB };
    /// This is a linear colorspace and the default colorspace for floating point surfaces. On Windows this is the scRGB colorspace, and on Apple platforms this is kCGColorSpaceExtendedLinearSRGB for EDR content.
    pub const Linear = Colorspace{ .value = C.SDL_COLORSPACE_SRGB_LINEAR };
    /// HDR10 is a non-linear HDR colorspace and the default colorspace for 10-bit surfaces.
    pub const Hdr10 = Colorspace{ .value = C.SDL_COLORSPACE_HDR10 };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601.
    pub const Jpeg = Colorspace{ .value = C.SDL_COLORSPACE_JPEG };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601.
    pub const BT601Limited = Colorspace{ .value = C.SDL_COLORSPACE_BT601_LIMITED };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601.
    pub const BT601Full = Colorspace{ .value = C.SDL_COLORSPACE_BT601_FULL };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709.
    pub const BT709Limited = Colorspace{ .value = C.SDL_COLORSPACE_BT709_LIMITED };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709.
    pub const BT709Full = Colorspace{ .value = C.SDL_COLORSPACE_BT709_FULL };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020.
    pub const BT2020Limited = Colorspace{ .value = C.SDL_COLORSPACE_BT2020_LIMITED };
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020.
    pub const BT2020Full = Colorspace{ .value = C.SDL_COLORSPACE_BT2020_FULL };
    /// The default colorspace for RGB surfaces if no colorspace is specified.
    pub const RgbDefault = Colorspace{ .value = C.SDL_COLORSPACE_RGB_DEFAULT };
    /// The default colorspace for YUV surfaces if no colorspace is specified.
    pub const YuvDefault = Colorspace{ .value = C.SDL_COLORSPACE_YUV_DEFAULT };

    /// Create a colorspace.
    pub fn define(
        color_type: ColorType,
        range: ColorRange,
        primaries: ColorPrimaries,
        transfer: TransferCharacteristics,
        matrix: MatrixCoefficients,
        chroma: ?ChromaLocation,
    ) Colorspace {
        const ret = C.SDL_DEFINE_COLORSPACE(
            @intFromEnum(color_type),
            @intFromEnum(range),
            @intFromEnum(primaries),
            @intFromEnum(transfer),
            @intFromEnum(matrix),
            if (chroma == null) C.SDL_CHROMA_LOCATION_NONE else @intFromEnum(chroma),
        );
        return Colorspace{ .value = ret };
    }

    /// Get the color space type.
    pub fn getType(
        self: Colorspace,
    ) ?ColorType {
        const ret = C.SDL_COLORSPACETYPE(
            self.value,
        );
        if (ret == C.SDL_COLOR_TYPE_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the color space range.
    pub fn getRange(
        self: Colorspace,
    ) ?ColorRange {
        const ret = C.SDL_COLORSPACERANGE(
            self.value,
        );
        if (ret == C.SDL_COLOR_RANGE_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the color space chroma.
    pub fn getChromaLocation(
        self: Colorspace,
    ) ?ChromaLocation {
        const ret = C.SDL_COLORSPACECHROMA(
            self.value,
        );
        if (ret == C.SDL_CHROMA_LOCATION_NONE)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the color space primaries.
    pub fn getColorPrimaries(
        self: Colorspace,
    ) ?ColorPrimaries {
        const ret = C.SDL_COLORSPACEPRIMARIES(
            self.value,
        );
        if (ret == C.SDL_COLOR_PRIMARIES_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the color space transfer characteristics.
    pub fn getTransferCharacteristics(
        self: Colorspace,
    ) ?TransferCharacteristics {
        const ret = C.SDL_COLORSPACETRANSFER(
            self.value,
        );
        if (ret == C.SDL_TRANSFER_CHARACTERISTICS_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the color space matrix.
    pub fn getMatrix(
        self: Colorspace,
    ) MatrixCoefficients {
        const ret = C.SDL_COLORSPACEMATRIX(
            self.value,
        );
        return @enumFromInt(ret);
    }

    /// If the matrix is BT601.
    pub fn isMatrixBT601(
        self: Colorspace,
    ) bool {
        const ret = C.SDL_ISCOLORSPACE_MATRIX_BT601(
            self.value,
        );
        return ret;
    }

    /// If the matrix is BT709.
    pub fn isMatrixBT709(
        self: Colorspace,
    ) bool {
        const ret = C.SDL_ISCOLORSPACE_MATRIX_BT709(
            self.value,
        );
        return ret;
    }

    /// If the matrix is BT2020 NCL.
    pub fn isMatrixBT2020_NCL(
        self: Colorspace,
    ) bool {
        const ret = C.SDL_ISCOLORSPACE_MATRIX_BT2020_NCL(
            self.value,
        );
        return ret;
    }

    /// If the color space is limited range.
    pub fn isLimitedRange(
        self: Colorspace,
    ) bool {
        const ret = C.SDL_ISCOLORSPACE_LIMITED_RANGE(
            self.value,
        );
        return ret;
    }

    /// If the color space is full range.
    pub fn isFullRange(
        self: Colorspace,
    ) bool {
        const ret = C.SDL_ISCOLORSPACE_FULL_RANGE(
            self.value,
        );
        return ret;
    }
};

/// Raw pixel value.
pub const Pixel = struct {
    value: u32,
};

/// Details about the format of a pixel.
pub const FormatDetails = struct {
    format: ?Format,
    bits_per_pixel: u8,
    bytes_per_pixel: u8,
    r_mask: u32,
    g_mask: u32,
    b_mask: u32,
    r_bits: u8,
    g_bits: u8,
    b_bits: u8,
    a_bits: u8,
    r_shift: u8,
    g_shift: u8,
    b_shift: u8,
    a_shift: u8,

    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_PixelFormatDetails) FormatDetails {
        return .{
            .format = if (data.format == C.SDL_PIXELFORMAT_UNKNOWN) null else Format{ .value = data.format },
            .bits_per_pixel = @intCast(data.bits_per_pixel),
            .bytes_per_pixel = @intCast(data.bytes_per_pixel),
            .r_mask = @intCast(data.Rmask),
            .g_mask = @intCast(data.Gmask),
            .b_mask = @intCast(data.Bmask),
            .r_bits = @intCast(data.Rbits),
            .g_bits = @intCast(data.Gbits),
            .b_bits = @intCast(data.Bbits),
            .a_bits = @intCast(data.Abits),
            .r_shift = @intCast(data.Rshift),
            .g_shift = @intCast(data.Gshift),
            .b_shift = @intCast(data.Bshift),
            .a_shift = @intCast(data.Ashift),
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: FormatDetails) C.SDL_PixelFormatDetails {
        return .{
            .format = if (self.format == null) C.SDL_PIXELFORMAT_UNKNOWN else self.format,
            .bits_per_pixel = @intCast(self.bits_per_pixel),
            .bytes_per_pixel = @intCast(self.bytes_per_pixel),
            .Rmask = @intCast(self.r_mask),
            .Gmask = @intCast(self.g_mask),
            .Bmask = @intCast(self.b_mask),
            .Rbits = @intCast(self.r_bits),
            .Gbits = @intCast(self.g_bits),
            .Bbits = @intCast(self.b_bits),
            .Abits = @intCast(self.a_bits),
            .Rshift = @intCast(self.r_shift),
            .Gshift = @intCast(self.g_shift),
            .Bshift = @intCast(self.b_shift),
            .Ashift = @intCast(self.a_shift),
        };
    }

    /// Map an RGB triple to an opaque pixel value for a given pixel format.
    pub fn mapRgb(
        self: FormatDetails,
        palette: ?Palette,
        r: u8,
        g: u8,
        b: u8,
    ) Pixel {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        const ret = C.SDL_MapRGB(
            &self_sdl,
            if (palette) |palette_val| palette_val.value else null,
            @intCast(r),
            @intCast(g),
            @intCast(b),
        );
        return Pixel{ .value = ret };
    }

    /// Map an RGBA quadruple to a transparent pixel value for a given pixel format.
    pub fn mapRgba(
        self: FormatDetails,
        palette: ?Palette,
        r: u8,
        g: u8,
        b: u8,
        a: u8,
    ) Pixel {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        const ret = C.SDL_MapRGBA(
            &self_sdl,
            if (palette) |palette_val| palette_val.value else null,
            @intCast(r),
            @intCast(g),
            @intCast(b),
            @intCast(a),
        );
        return Pixel{ .value = ret };
    }

    /// Get RGB values from a pixel in the specified format.
    pub fn getRgb(
        self: FormatDetails,
        pixel: Pixel,
        palette: ?Palette,
    ) struct { r: u8, g: u8, b: u8 } {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        const ret = C.SDL_GetRGB(
            @intCast(pixel.value),
            &self_sdl,
            if (palette) |palette_val| palette_val.value else null,
            &r,
            &g,
            &b,
        );
        _ = ret;
        return .{ .r = r, .g = g, .b = b };
    }

    /// Get RGBA values from a pixel in the specified format.
    pub fn getRgba(
        self: FormatDetails,
        pixel: Pixel,
        palette: ?Palette,
    ) struct { r: u8, g: u8, b: u8, a: u8 } {
        const self_sdl: C.SDL_PixelFormatDetails = self.toSdl();
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        var a: u8 = undefined;
        const ret = C.SDL_GetRGBA(
            @intCast(pixel.value),
            &self_sdl,
            if (palette) |palette_val| palette_val.value else null,
            &r,
            &g,
            &b,
            &a,
        );
        _ = ret;
        return .{ .r = r, .g = g, .b = b, .a = a };
    }
};

/// Get the order type of a pixel type.
fn OrderType(pixel_type: Type) type {
    return switch (pixel_type) {
        .Index1, .Index2, .Index4, .Index8 => IndexOrder,
        .Packed8, .Packed16, .Packed32 => PackedOrder,
        .ArrayU8, .ArrayU16, .ArrayU32, .ArrayF16, .ArrayF32 => ArrayOrder,
    };
}

/// A fully opaque 8-bit alpha value.
pub const alpha_opaque: u8 = 255;

/// A fully transparent 8-bit alpha value.
pub const alpha_transparent: u8 = 0;

/// A fully opaque float alpha value.
pub const alpha_opaque_float: f32 = 1;

/// A fully transparent float alpha value.
pub const alpha_transparent_float: f32 = 0;

/// A structure that represents a color as RGBA components.
pub const Color = C.SDL_Color;

/// The bits of this structure can be directly reinterpreted as a float-packed.
pub const FColor = C.SDL_FColor;
