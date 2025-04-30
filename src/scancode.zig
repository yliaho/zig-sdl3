const C = @import("c.zig").C;
const std = @import("std");

/// The SDL keyboard scancode representation.
///
/// ## Remarks
/// An SDL scancode is the physical representation of a key on the keyboard, independent of language and keyboard mapping.
///
/// Values of this type are used to represent keyboard keys, among other places in the scancode field of the `events.Keyboard` structure.
///
/// The values in this enumeration are based on the USB usage page standard: https://usb.org/sites/default/files/hut1_5.pdf
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Scancode = enum(C.SDL_Scancode) {
    a = C.SDL_SCANCODE_A,
    b = C.SDL_SCANCODE_B,
    c = C.SDL_SCANCODE_C,
    d = C.SDL_SCANCODE_D,
    e = C.SDL_SCANCODE_E,
    f = C.SDL_SCANCODE_F,
    g = C.SDL_SCANCODE_G,
    h = C.SDL_SCANCODE_H,
    i = C.SDL_SCANCODE_I,
    j = C.SDL_SCANCODE_J,
    k = C.SDL_SCANCODE_K,
    l = C.SDL_SCANCODE_L,
    m = C.SDL_SCANCODE_M,
    n = C.SDL_SCANCODE_N,
    o = C.SDL_SCANCODE_O,
    p = C.SDL_SCANCODE_P,
    q = C.SDL_SCANCODE_Q,
    r = C.SDL_SCANCODE_R,
    s = C.SDL_SCANCODE_S,
    t = C.SDL_SCANCODE_T,
    u = C.SDL_SCANCODE_U,
    v = C.SDL_SCANCODE_V,
    w = C.SDL_SCANCODE_W,
    x = C.SDL_SCANCODE_X,
    y = C.SDL_SCANCODE_Y,
    z = C.SDL_SCANCODE_Z,
    one = C.SDL_SCANCODE_1,
    two = C.SDL_SCANCODE_2,
    three = C.SDL_SCANCODE_3,
    four = C.SDL_SCANCODE_4,
    five = C.SDL_SCANCODE_5,
    six = C.SDL_SCANCODE_6,
    seven = C.SDL_SCANCODE_7,
    eight = C.SDL_SCANCODE_8,
    nine = C.SDL_SCANCODE_9,
    zero = C.SDL_SCANCODE_0,
    return_key = C.SDL_SCANCODE_RETURN,
    escape = C.SDL_SCANCODE_ESCAPE,
    backspace = C.SDL_SCANCODE_BACKSPACE,
    tab = C.SDL_SCANCODE_TAB,
    space = C.SDL_SCANCODE_SPACE,
    minus = C.SDL_SCANCODE_MINUS,
    equals = C.SDL_SCANCODE_EQUALS,
    left_bracket = C.SDL_SCANCODE_LEFTBRACKET,
    right_bracket = C.SDL_SCANCODE_RIGHTBRACKET,

    /// Located at the lower left of the return key on ISO keyboards and at the right end of the QWERTY row on ANSI keyboards.
    /// Produces REVERSE SOLIDUS (backslash) and VERTICAL LINE in a US layout, REVERSE SOLIDUS and VERTICAL LINE in a UK Mac layout,
    /// NUMBER SIGN and TILDE in a UK Windows layout, DOLLAR SIGN and POUND SIGN in a Swiss German layout, NUMBER SIGN and APOSTROPHE in a German layout,
    /// GRAVE ACCENT and POUND SIGN in a French Mac layout, and ASTERISK and MICRO SIGN in a French Windows layout.
    backslash = C.SDL_SCANCODE_BACKSLASH,

    /// ISO USB keyboards actually use this code instead of 49 for the same key, but all OSes I've seen treat the two codes identically.
    /// So, as an implementor, unless your keyboard generates both of those codes and your OS treats them differently,
    /// you should generate SDL_SCANCODE_BACKSLASH instead of this code.
    /// As a user, you should not rely on this code because SDL will never generate it with most (all?) keyboards.
    non_us_hash = C.SDL_SCANCODE_NONUSHASH,
    semicolon = C.SDL_SCANCODE_SEMICOLON,
    apostrophe = C.SDL_SCANCODE_APOSTROPHE,

    /// Located in the top left corner (on both ANSI and ISO keyboards).
    /// Produces GRAVE ACCENT and TILDE in a US Windows layout and in US and UK Mac layouts on ANSI keyboards, GRAVE ACCENT and NOT SIGN in a UK Windows layout,
    /// SECTION SIGN and PLUS-MINUS SIGN in US and UK Mac layouts on ISO keyboards, SECTION SIGN and DEGREE SIGN in a Swiss German layout (Mac: only on ISO keyboards),
    /// CIRCUMFLEX ACCENT and DEGREE SIGN in a German layout (Mac: only on ISO keyboards), SUPERSCRIPT TWO and TILDE in a French Windows layout,
    /// COMMERCIAL AT and NUMBER SIGN in a French Mac layout on ISO keyboards, and LESS-THAN SIGN and GREATER-THAN SIGN in a Swiss German, German,
    /// or French Mac layout on ANSI keyboards.
    grave = C.SDL_SCANCODE_GRAVE,
    comma = C.SDL_SCANCODE_COMMA,
    period = C.SDL_SCANCODE_PERIOD,
    slash = C.SDL_SCANCODE_SLASH,
    caps_lock = C.SDL_SCANCODE_CAPSLOCK,
    func1 = C.SDL_SCANCODE_F1,
    func2 = C.SDL_SCANCODE_F2,
    func3 = C.SDL_SCANCODE_F3,
    func4 = C.SDL_SCANCODE_F4,
    func5 = C.SDL_SCANCODE_F5,
    func6 = C.SDL_SCANCODE_F6,
    func7 = C.SDL_SCANCODE_F7,
    func8 = C.SDL_SCANCODE_F8,
    func9 = C.SDL_SCANCODE_F9,
    func10 = C.SDL_SCANCODE_F10,
    func11 = C.SDL_SCANCODE_F11,
    func12 = C.SDL_SCANCODE_F12,
    print_screen = C.SDL_SCANCODE_PRINTSCREEN,
    scroll_lock = C.SDL_SCANCODE_SCROLLLOCK,
    pause = C.SDL_SCANCODE_PAUSE,

    /// Insert on PC, help on some Mac keyboards (but does send code 73, not 117).
    insert = C.SDL_SCANCODE_INSERT,
    home = C.SDL_SCANCODE_HOME,
    pageup = C.SDL_SCANCODE_PAGEUP,
    delete = C.SDL_SCANCODE_DELETE,
    end = C.SDL_SCANCODE_END,
    pagedown = C.SDL_SCANCODE_PAGEDOWN,
    right = C.SDL_SCANCODE_RIGHT,
    left = C.SDL_SCANCODE_LEFT,
    down = C.SDL_SCANCODE_DOWN,
    up = C.SDL_SCANCODE_UP,

    /// Num lock on PC, clear on Mac keyboards.
    num_lock_clear = C.SDL_SCANCODE_NUMLOCKCLEAR,
    kp_divide = C.SDL_SCANCODE_KP_DIVIDE,
    kp_multiply = C.SDL_SCANCODE_KP_MULTIPLY,
    kp_minus = C.SDL_SCANCODE_KP_MINUS,
    kp_plus = C.SDL_SCANCODE_KP_PLUS,
    kp_enter = C.SDL_SCANCODE_KP_ENTER,
    kp_1 = C.SDL_SCANCODE_KP_1,
    kp_2 = C.SDL_SCANCODE_KP_2,
    kp_3 = C.SDL_SCANCODE_KP_3,
    kp_4 = C.SDL_SCANCODE_KP_4,
    kp_5 = C.SDL_SCANCODE_KP_5,
    kp_6 = C.SDL_SCANCODE_KP_6,
    kp_7 = C.SDL_SCANCODE_KP_7,
    kp_8 = C.SDL_SCANCODE_KP_8,
    kp_9 = C.SDL_SCANCODE_KP_9,
    kp_0 = C.SDL_SCANCODE_KP_0,
    kp_period = C.SDL_SCANCODE_KP_PERIOD,

    /// This is the additional key that ISO keyboards have over ANSI ones, located between left shift and Y.
    /// Produces GRAVE ACCENT and TILDE in a US or UK Mac layout, REVERSE SOLIDUS (backslash) and VERTICAL LINE in a US or UK Windows layout,
    /// and LESS-THAN SIGN and GREATER-THAN SIGN in a Swiss German, German, or French layout.
    non_us_backslash = C.SDL_SCANCODE_NONUSBACKSLASH,

    /// Windows contextual menu, compose.
    application = C.SDL_SCANCODE_APPLICATION,

    /// The USB document says this is a status flag, not a physical key, but some Mac keyboards do have a power key.
    power = C.SDL_SCANCODE_POWER,
    kp_equals = C.SDL_SCANCODE_KP_EQUALS,
    func13 = C.SDL_SCANCODE_F13,
    func14 = C.SDL_SCANCODE_F14,
    func15 = C.SDL_SCANCODE_F15,
    func16 = C.SDL_SCANCODE_F16,
    func17 = C.SDL_SCANCODE_F17,
    func18 = C.SDL_SCANCODE_F18,
    func19 = C.SDL_SCANCODE_F19,
    func20 = C.SDL_SCANCODE_F20,
    func21 = C.SDL_SCANCODE_F21,
    func22 = C.SDL_SCANCODE_F22,
    func23 = C.SDL_SCANCODE_F23,
    func24 = C.SDL_SCANCODE_F24,
    execute = C.SDL_SCANCODE_EXECUTE,

    /// AL Integrated Help Center.
    help = C.SDL_SCANCODE_HELP,

    /// Menu (show menu).
    menu = C.SDL_SCANCODE_MENU,
    select = C.SDL_SCANCODE_SELECT,

    /// AC Stop.
    stop = C.SDL_SCANCODE_STOP,

    /// AC Redo/Repeat.
    again = C.SDL_SCANCODE_AGAIN,

    /// AC Undo.
    undo = C.SDL_SCANCODE_UNDO,

    /// AC Cut.
    cut = C.SDL_SCANCODE_CUT,

    /// AC Copy.
    copy = C.SDL_SCANCODE_COPY,

    /// AC Paste.
    paste = C.SDL_SCANCODE_PASTE,

    /// AC Find.
    find = C.SDL_SCANCODE_FIND,
    mute = C.SDL_SCANCODE_MUTE,
    volume_up = C.SDL_SCANCODE_VOLUMEUP,
    volume_down = C.SDL_SCANCODE_VOLUMEDOWN,
    kp_comma = C.SDL_SCANCODE_KP_COMMA,
    kp_equals_as_400 = C.SDL_SCANCODE_KP_EQUALSAS400,

    /// Used on Asian keyboards, see footnotes in USB doc.
    international1 = C.SDL_SCANCODE_INTERNATIONAL1,
    international2 = C.SDL_SCANCODE_INTERNATIONAL2,

    /// Yen.
    international3 = C.SDL_SCANCODE_INTERNATIONAL3,
    international4 = C.SDL_SCANCODE_INTERNATIONAL4,
    international5 = C.SDL_SCANCODE_INTERNATIONAL5,
    international6 = C.SDL_SCANCODE_INTERNATIONAL6,
    international7 = C.SDL_SCANCODE_INTERNATIONAL7,
    international8 = C.SDL_SCANCODE_INTERNATIONAL8,
    international9 = C.SDL_SCANCODE_INTERNATIONAL9,

    /// Hangul/English toggle.
    lang1 = C.SDL_SCANCODE_LANG1,

    /// Hanja conversion.
    lang2 = C.SDL_SCANCODE_LANG2,

    /// Katakana.
    lang3 = C.SDL_SCANCODE_LANG3,

    /// Hiragana.
    lang4 = C.SDL_SCANCODE_LANG4,

    /// Zenkaku/Hankaku.
    lang5 = C.SDL_SCANCODE_LANG5,

    /// Reserved.
    lang6 = C.SDL_SCANCODE_LANG6,

    /// Reserved.
    lang7 = C.SDL_SCANCODE_LANG7,

    /// Reserved.
    lang8 = C.SDL_SCANCODE_LANG8,

    /// Reserved.
    lang9 = C.SDL_SCANCODE_LANG9,

    /// Erase-Eaze.
    alt_erase = C.SDL_SCANCODE_ALTERASE,
    sysreq = C.SDL_SCANCODE_SYSREQ,

    /// AC Cancel.
    cancel = C.SDL_SCANCODE_CANCEL,
    clear = C.SDL_SCANCODE_CLEAR,
    prior = C.SDL_SCANCODE_PRIOR,
    return2 = C.SDL_SCANCODE_RETURN2,
    separator = C.SDL_SCANCODE_SEPARATOR,
    out = C.SDL_SCANCODE_OUT,
    oper = C.SDL_SCANCODE_OPER,
    clear_again = C.SDL_SCANCODE_CLEARAGAIN,
    cr_sel = C.SDL_SCANCODE_CRSEL,
    ex_sel = C.SDL_SCANCODE_EXSEL,
    kp_00 = C.SDL_SCANCODE_KP_00,
    kp_000 = C.SDL_SCANCODE_KP_000,
    thousands_separator = C.SDL_SCANCODE_THOUSANDSSEPARATOR,
    decimals_eparator = C.SDL_SCANCODE_DECIMALSEPARATOR,
    currency_unit = C.SDL_SCANCODE_CURRENCYUNIT,
    currency_subunit = C.SDL_SCANCODE_CURRENCYSUBUNIT,
    kp_left_paren = C.SDL_SCANCODE_KP_LEFTPAREN,
    kp_right_paren = C.SDL_SCANCODE_KP_RIGHTPAREN,
    kp_left_brace = C.SDL_SCANCODE_KP_LEFTBRACE,
    kp_right_brace = C.SDL_SCANCODE_KP_RIGHTBRACE,
    kp_tab = C.SDL_SCANCODE_KP_TAB,
    kp_backspace = C.SDL_SCANCODE_KP_BACKSPACE,
    kp_a = C.SDL_SCANCODE_KP_A,
    kp_b = C.SDL_SCANCODE_KP_B,
    kp_c = C.SDL_SCANCODE_KP_C,
    kp_d = C.SDL_SCANCODE_KP_D,
    kp_e = C.SDL_SCANCODE_KP_E,
    kp_f = C.SDL_SCANCODE_KP_F,
    kp_xor = C.SDL_SCANCODE_KP_XOR,
    kp_power = C.SDL_SCANCODE_KP_POWER,
    kp_percent = C.SDL_SCANCODE_KP_PERCENT,
    kp_less = C.SDL_SCANCODE_KP_LESS,
    kp_greater = C.SDL_SCANCODE_KP_GREATER,
    kp_ampersand = C.SDL_SCANCODE_KP_AMPERSAND,
    kp_dbl_ampersand = C.SDL_SCANCODE_KP_DBLAMPERSAND,
    kp_vertical_bar = C.SDL_SCANCODE_KP_VERTICALBAR,
    kp_dbl_vertical_bar = C.SDL_SCANCODE_KP_DBLVERTICALBAR,
    kp_colon = C.SDL_SCANCODE_KP_COLON,
    kp_hash = C.SDL_SCANCODE_KP_HASH,
    kp_space = C.SDL_SCANCODE_KP_SPACE,
    kp_at = C.SDL_SCANCODE_KP_AT,
    kp_exclam = C.SDL_SCANCODE_KP_EXCLAM,
    kp_mem_store = C.SDL_SCANCODE_KP_MEMSTORE,
    kp_mem_recall = C.SDL_SCANCODE_KP_MEMRECALL,
    kp_mem_clear = C.SDL_SCANCODE_KP_MEMCLEAR,
    kp_mem_add = C.SDL_SCANCODE_KP_MEMADD,
    kp_mem_subtract = C.SDL_SCANCODE_KP_MEMSUBTRACT,
    kp_mem_multiply = C.SDL_SCANCODE_KP_MEMMULTIPLY,
    kp_mem_divide = C.SDL_SCANCODE_KP_MEMDIVIDE,
    kp_plus_minus = C.SDL_SCANCODE_KP_PLUSMINUS,
    kp_clear = C.SDL_SCANCODE_KP_CLEAR,
    kp_clear_entry = C.SDL_SCANCODE_KP_CLEARENTRY,
    kp_binary = C.SDL_SCANCODE_KP_BINARY,
    kp_octal = C.SDL_SCANCODE_KP_OCTAL,
    kp_decimal = C.SDL_SCANCODE_KP_DECIMAL,
    kp_hexadecimal = C.SDL_SCANCODE_KP_HEXADECIMAL,
    left_ctrl = C.SDL_SCANCODE_LCTRL,
    left_shift = C.SDL_SCANCODE_LSHIFT,

    /// Alt, option.
    left_alt = C.SDL_SCANCODE_LALT,

    /// Windows, command (apple), meta.
    left_gui = C.SDL_SCANCODE_LGUI,
    right_ctrl = C.SDL_SCANCODE_RCTRL,
    right_shift = C.SDL_SCANCODE_RSHIFT,

    /// Alt gr, option.
    right_alt = C.SDL_SCANCODE_RALT,

    /// Windows, command (apple), meta.
    right_gui = C.SDL_SCANCODE_RGUI,

    /// I'm not sure if this is really not covered by any of the above, but since there's a special `keycode.KeyModifier.mode` for it I'm adding it here.
    mode = C.SDL_SCANCODE_MODE,

    /// Sleep.
    sleep = C.SDL_SCANCODE_SLEEP,

    /// Wake.
    wake = C.SDL_SCANCODE_WAKE,

    /// Channel increment.
    channel_increment = C.SDL_SCANCODE_CHANNEL_INCREMENT,

    /// Channel decrement.
    channel_decrement = C.SDL_SCANCODE_CHANNEL_DECREMENT,

    /// Play.
    media_play = C.SDL_SCANCODE_MEDIA_PLAY,

    /// Pause.
    media_pause = C.SDL_SCANCODE_MEDIA_PAUSE,

    /// Record.
    media_record = C.SDL_SCANCODE_MEDIA_RECORD,

    /// Fast forward.
    media_fast_forward = C.SDL_SCANCODE_MEDIA_FAST_FORWARD,

    /// Rewind.
    media_rewind = C.SDL_SCANCODE_MEDIA_REWIND,

    /// Next track.
    media_next_track = C.SDL_SCANCODE_MEDIA_NEXT_TRACK,

    /// Previous track.
    media_previous_track = C.SDL_SCANCODE_MEDIA_PREVIOUS_TRACK,

    /// Stop.
    media_stop = C.SDL_SCANCODE_MEDIA_STOP,

    /// Eject.
    media_eject = C.SDL_SCANCODE_MEDIA_EJECT,

    /// Play/pause.
    media_play_pause = C.SDL_SCANCODE_MEDIA_PLAY_PAUSE,

    /// Media select.
    media_select = C.SDL_SCANCODE_MEDIA_SELECT,

    /// AC New.
    ac_new = C.SDL_SCANCODE_AC_NEW,

    /// AC Open.
    ac_open = C.SDL_SCANCODE_AC_OPEN,

    /// AC Close.
    ac_close = C.SDL_SCANCODE_AC_CLOSE,

    /// AC Exist.
    ac_exit = C.SDL_SCANCODE_AC_EXIT,

    /// AC Save.
    ac_save = C.SDL_SCANCODE_AC_SAVE,

    /// AC Print.
    ac_print = C.SDL_SCANCODE_AC_PRINT,

    /// AC Properties.
    ac_properties = C.SDL_SCANCODE_AC_PROPERTIES,

    /// AC Search.
    ac_search = C.SDL_SCANCODE_AC_SEARCH,

    /// AC Home.
    ac_home = C.SDL_SCANCODE_AC_HOME,

    /// AC Back.
    ac_back = C.SDL_SCANCODE_AC_BACK,

    /// AC Forward.
    ac_forward = C.SDL_SCANCODE_AC_FORWARD,

    /// AC Stop.
    ac_stop = C.SDL_SCANCODE_AC_STOP,

    /// AC Refresh.
    ac_refresh = C.SDL_SCANCODE_AC_REFRESH,

    /// AC Bookmarks.
    ac_bookmarks = C.SDL_SCANCODE_AC_BOOKMARKS,

    /// Usually situated below the display on phones and used as a multi-function feature key for selecting a software defined function shown on the bottom left of the display.
    soft_left = C.SDL_SCANCODE_SOFTLEFT,

    /// Usually situated below the display on phones and used as a multi-function feature key for selecting a software defined function shown on the bottom right of the display.
    soft_right = C.SDL_SCANCODE_SOFTRIGHT,

    /// Used for accepting phone calls.
    call = C.SDL_SCANCODE_CALL,

    /// Used for rejecting phone calls.
    end_call = C.SDL_SCANCODE_ENDCALL,

    /// Create an unmanaged scancode from a scancode enum.
    ///
    /// ## Function Parameters
    /// * `self`: scancode enum to make unmanaged.
    ///
    /// ## Return Value
    /// Returns an unmanaged SDL scancode.
    ///
    /// ## Remarks
    /// This makes a copy of the scancode provided.
    ///
    /// ## Version
    /// This function is provided by zig-sdl3.
    pub fn toSdl(self: Scancode) C.SDL_Scancode {
        return @intFromEnum(self);
    }

    /// Create a scancode enum from an SDL scancode.
    ///
    /// ## Function Parameters
    /// * `event`: SDL scancode to manage.
    ///
    /// ## Return Value
    /// A managed scancode enum.
    ///
    /// ## Remarks
    /// This makes a copy of the scancode provided.
    ///
    /// ## Version
    /// This function is provided by zig-sdl3.
    pub fn fromSdl(key_code: C.SDL_Scancode) Scancode {
        return @enumFromInt(key_code);
    }
};

// Scancode tests.
test "Scancode" {
    std.testing.refAllDecls(@This());
}
