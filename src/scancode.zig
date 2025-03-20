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
pub const Scancode = struct {
    value: u9,
    pub const a = Scancode{ .value = C.SDL_SCANCODE_A };
    pub const b = Scancode{ .value = C.SDL_SCANCODE_B };
    pub const c = Scancode{ .value = C.SDL_SCANCODE_C };
    pub const d = Scancode{ .value = C.SDL_SCANCODE_D };
    pub const e = Scancode{ .value = C.SDL_SCANCODE_E };
    pub const f = Scancode{ .value = C.SDL_SCANCODE_F };
    pub const g = Scancode{ .value = C.SDL_SCANCODE_G };
    pub const h = Scancode{ .value = C.SDL_SCANCODE_H };
    pub const i = Scancode{ .value = C.SDL_SCANCODE_I };
    pub const j = Scancode{ .value = C.SDL_SCANCODE_J };
    pub const k = Scancode{ .value = C.SDL_SCANCODE_K };
    pub const l = Scancode{ .value = C.SDL_SCANCODE_L };
    pub const m = Scancode{ .value = C.SDL_SCANCODE_M };
    pub const n = Scancode{ .value = C.SDL_SCANCODE_N };
    pub const o = Scancode{ .value = C.SDL_SCANCODE_O };
    pub const p = Scancode{ .value = C.SDL_SCANCODE_P };
    pub const q = Scancode{ .value = C.SDL_SCANCODE_Q };
    pub const r = Scancode{ .value = C.SDL_SCANCODE_R };
    pub const s = Scancode{ .value = C.SDL_SCANCODE_S };
    pub const t = Scancode{ .value = C.SDL_SCANCODE_T };
    pub const u = Scancode{ .value = C.SDL_SCANCODE_U };
    pub const v = Scancode{ .value = C.SDL_SCANCODE_V };
    pub const w = Scancode{ .value = C.SDL_SCANCODE_W };
    pub const x = Scancode{ .value = C.SDL_SCANCODE_X };
    pub const y = Scancode{ .value = C.SDL_SCANCODE_Y };
    pub const z = Scancode{ .value = C.SDL_SCANCODE_Z };
    pub const one = Scancode{ .value = C.SDL_SCANCODE_1 };
    pub const two = Scancode{ .value = C.SDL_SCANCODE_2 };
    pub const three = Scancode{ .value = C.SDL_SCANCODE_3 };
    pub const four = Scancode{ .value = C.SDL_SCANCODE_4 };
    pub const five = Scancode{ .value = C.SDL_SCANCODE_5 };
    pub const six = Scancode{ .value = C.SDL_SCANCODE_6 };
    pub const seven = Scancode{ .value = C.SDL_SCANCODE_7 };
    pub const eight = Scancode{ .value = C.SDL_SCANCODE_8 };
    pub const nine = Scancode{ .value = C.SDL_SCANCODE_9 };
    pub const zero = Scancode{ .value = C.SDL_SCANCODE_0 };
    pub const return_key = Scancode{ .value = C.SDL_SCANCODE_RETURN };
    pub const escape = Scancode{ .value = C.SDL_SCANCODE_ESCAPE };
    pub const backspace = Scancode{ .value = C.SDL_SCANCODE_BACKSPACE };
    pub const tab = Scancode{ .value = C.SDL_SCANCODE_TAB };
    pub const space = Scancode{ .value = C.SDL_SCANCODE_SPACE };
    pub const minus = Scancode{ .value = C.SDL_SCANCODE_MINUS };
    pub const equals = Scancode{ .value = C.SDL_SCANCODE_EQUALS };
    pub const leftbracket = Scancode{ .value = C.SDL_SCANCODE_LEFTBRACKET };
    pub const rightbracket = Scancode{ .value = C.SDL_SCANCODE_RIGHTBRACKET };

    /// Located at the lower left of the return key on ISO keyboards and at the right end of the QWERTY row on ANSI keyboards.
    /// Produces REVERSE SOLIDUS (backslash) and VERTICAL LINE in a US layout, REVERSE SOLIDUS and VERTICAL LINE in a UK Mac layout,
    /// NUMBER SIGN and TILDE in a UK Windows layout, DOLLAR SIGN and POUND SIGN in a Swiss German layout, NUMBER SIGN and APOSTROPHE in a German layout,
    /// GRAVE ACCENT and POUND SIGN in a French Mac layout, and ASTERISK and MICRO SIGN in a French Windows layout.
    pub const backslash = Scancode{ .value = C.SDL_SCANCODE_BACKSLASH };

    /// ISO USB keyboards actually use this code instead of 49 for the same key, but all OSes I've seen treat the two codes identically.
    /// So, as an implementor, unless your keyboard generates both of those codes and your OS treats them differently,
    /// you should generate SDL_SCANCODE_BACKSLASH instead of this code.
    /// As a user, you should not rely on this code because SDL will never generate it with most (all?) keyboards.
    pub const nonushash = Scancode{ .value = C.SDL_SCANCODE_NONUSHASH };
    pub const semicolon = Scancode{ .value = C.SDL_SCANCODE_SEMICOLON };
    pub const apostrophe = Scancode{ .value = C.SDL_SCANCODE_APOSTROPHE };

    /// Located in the top left corner (on both ANSI and ISO keyboards).
    /// Produces GRAVE ACCENT and TILDE in a US Windows layout and in US and UK Mac layouts on ANSI keyboards, GRAVE ACCENT and NOT SIGN in a UK Windows layout,
    /// SECTION SIGN and PLUS-MINUS SIGN in US and UK Mac layouts on ISO keyboards, SECTION SIGN and DEGREE SIGN in a Swiss German layout (Mac: only on ISO keyboards),
    /// CIRCUMFLEX ACCENT and DEGREE SIGN in a German layout (Mac: only on ISO keyboards), SUPERSCRIPT TWO and TILDE in a French Windows layout,
    /// COMMERCIAL AT and NUMBER SIGN in a French Mac layout on ISO keyboards, and LESS-THAN SIGN and GREATER-THAN SIGN in a Swiss German, German,
    /// or French Mac layout on ANSI keyboards.
    pub const grave = Scancode{ .value = C.SDL_SCANCODE_GRAVE };
    pub const comma = Scancode{ .value = C.SDL_SCANCODE_COMMA };
    pub const period = Scancode{ .value = C.SDL_SCANCODE_PERIOD };
    pub const slash = Scancode{ .value = C.SDL_SCANCODE_SLASH };
    pub const capslock = Scancode{ .value = C.SDL_SCANCODE_CAPSLOCK };
    pub const func1 = Scancode{ .value = C.SDL_SCANCODE_F1 };
    pub const func2 = Scancode{ .value = C.SDL_SCANCODE_F2 };
    pub const func3 = Scancode{ .value = C.SDL_SCANCODE_F3 };
    pub const func4 = Scancode{ .value = C.SDL_SCANCODE_F4 };
    pub const func5 = Scancode{ .value = C.SDL_SCANCODE_F5 };
    pub const func6 = Scancode{ .value = C.SDL_SCANCODE_F6 };
    pub const func7 = Scancode{ .value = C.SDL_SCANCODE_F7 };
    pub const func8 = Scancode{ .value = C.SDL_SCANCODE_F8 };
    pub const func9 = Scancode{ .value = C.SDL_SCANCODE_F9 };
    pub const func10 = Scancode{ .value = C.SDL_SCANCODE_F10 };
    pub const func11 = Scancode{ .value = C.SDL_SCANCODE_F11 };
    pub const func12 = Scancode{ .value = C.SDL_SCANCODE_F12 };
    pub const printscreen = Scancode{ .value = C.SDL_SCANCODE_PRINTSCREEN };
    pub const scrolllock = Scancode{ .value = C.SDL_SCANCODE_SCROLLLOCK };
    pub const pause = Scancode{ .value = C.SDL_SCANCODE_PAUSE };

    /// Insert on PC, help on some Mac keyboards (but does send code 73, not 117).
    pub const insert = Scancode{ .value = C.SDL_SCANCODE_INSERT };
    pub const home = Scancode{ .value = C.SDL_SCANCODE_HOME };
    pub const pageup = Scancode{ .value = C.SDL_SCANCODE_PAGEUP };
    pub const delete = Scancode{ .value = C.SDL_SCANCODE_DELETE };
    pub const end = Scancode{ .value = C.SDL_SCANCODE_END };
    pub const pagedown = Scancode{ .value = C.SDL_SCANCODE_PAGEDOWN };
    pub const right = Scancode{ .value = C.SDL_SCANCODE_RIGHT };
    pub const left = Scancode{ .value = C.SDL_SCANCODE_LEFT };
    pub const down = Scancode{ .value = C.SDL_SCANCODE_DOWN };
    pub const up = Scancode{ .value = C.SDL_SCANCODE_UP };

    /// Num lock on PC, clear on Mac keyboards.
    pub const numlockclear = Scancode{ .value = C.SDL_SCANCODE_NUMLOCKCLEAR };
    pub const kp_divide = Scancode{ .value = C.SDL_SCANCODE_KP_DIVIDE };
    pub const kp_multiply = Scancode{ .value = C.SDL_SCANCODE_KP_MULTIPLY };
    pub const kp_minus = Scancode{ .value = C.SDL_SCANCODE_KP_MINUS };
    pub const kp_plus = Scancode{ .value = C.SDL_SCANCODE_KP_PLUS };
    pub const kp_enter = Scancode{ .value = C.SDL_SCANCODE_KP_ENTER };
    pub const kp_1 = Scancode{ .value = C.SDL_SCANCODE_KP_1 };
    pub const kp_2 = Scancode{ .value = C.SDL_SCANCODE_KP_2 };
    pub const kp_3 = Scancode{ .value = C.SDL_SCANCODE_KP_3 };
    pub const kp_4 = Scancode{ .value = C.SDL_SCANCODE_KP_4 };
    pub const kp_5 = Scancode{ .value = C.SDL_SCANCODE_KP_5 };
    pub const kp_6 = Scancode{ .value = C.SDL_SCANCODE_KP_6 };
    pub const kp_7 = Scancode{ .value = C.SDL_SCANCODE_KP_7 };
    pub const kp_8 = Scancode{ .value = C.SDL_SCANCODE_KP_8 };
    pub const kp_9 = Scancode{ .value = C.SDL_SCANCODE_KP_9 };
    pub const kp_0 = Scancode{ .value = C.SDL_SCANCODE_KP_0 };
    pub const kp_period = Scancode{ .value = C.SDL_SCANCODE_KP_PERIOD };

    /// This is the additional key that ISO keyboards have over ANSI ones, located between left shift and Y.
    /// Produces GRAVE ACCENT and TILDE in a US or UK Mac layout, REVERSE SOLIDUS (backslash) and VERTICAL LINE in a US or UK Windows layout,
    /// and LESS-THAN SIGN and GREATER-THAN SIGN in a Swiss German, German, or French layout.
    pub const nonusbackslash = Scancode{ .value = C.SDL_SCANCODE_NONUSBACKSLASH };

    /// Windows contextual menu, compose.
    pub const application = Scancode{ .value = C.SDL_SCANCODE_APPLICATION };

    /// The USB document says this is a status flag, not a physical key, but some Mac keyboards do have a power key.
    pub const power = Scancode{ .value = C.SDL_SCANCODE_POWER };
    pub const kp_equals = Scancode{ .value = C.SDL_SCANCODE_KP_EQUALS };
    pub const func13 = Scancode{ .value = C.SDL_SCANCODE_F13 };
    pub const func14 = Scancode{ .value = C.SDL_SCANCODE_F14 };
    pub const func15 = Scancode{ .value = C.SDL_SCANCODE_F15 };
    pub const func16 = Scancode{ .value = C.SDL_SCANCODE_F16 };
    pub const func17 = Scancode{ .value = C.SDL_SCANCODE_F17 };
    pub const func18 = Scancode{ .value = C.SDL_SCANCODE_F18 };
    pub const func19 = Scancode{ .value = C.SDL_SCANCODE_F19 };
    pub const func20 = Scancode{ .value = C.SDL_SCANCODE_F20 };
    pub const func21 = Scancode{ .value = C.SDL_SCANCODE_F21 };
    pub const func22 = Scancode{ .value = C.SDL_SCANCODE_F22 };
    pub const func23 = Scancode{ .value = C.SDL_SCANCODE_F23 };
    pub const func24 = Scancode{ .value = C.SDL_SCANCODE_F24 };
    pub const execute = Scancode{ .value = C.SDL_SCANCODE_EXECUTE };

    /// AL Integrated Help Center.
    pub const help = Scancode{ .value = C.SDL_SCANCODE_HELP };

    /// Menu (show menu).
    pub const menu = Scancode{ .value = C.SDL_SCANCODE_MENU };
    pub const select = Scancode{ .value = C.SDL_SCANCODE_SELECT };

    /// AC Stop.
    pub const stop = Scancode{ .value = C.SDL_SCANCODE_STOP };

    /// AC Redo/Repeat.
    pub const again = Scancode{ .value = C.SDL_SCANCODE_AGAIN };

    /// AC Undo.
    pub const undo = Scancode{ .value = C.SDL_SCANCODE_UNDO };

    /// AC Cut.
    pub const cut = Scancode{ .value = C.SDL_SCANCODE_CUT };

    /// AC Copy.
    pub const copy = Scancode{ .value = C.SDL_SCANCODE_COPY };

    /// AC Paste.
    pub const paste = Scancode{ .value = C.SDL_SCANCODE_PASTE };

    /// AC Find.
    pub const find = Scancode{ .value = C.SDL_SCANCODE_FIND };
    pub const mute = Scancode{ .value = C.SDL_SCANCODE_MUTE };
    pub const volumeup = Scancode{ .value = C.SDL_SCANCODE_VOLUMEUP };
    pub const volumedown = Scancode{ .value = C.SDL_SCANCODE_VOLUMEDOWN };
    pub const kp_comma = Scancode{ .value = C.SDL_SCANCODE_KP_COMMA };
    pub const kp_equalsas400 = Scancode{ .value = C.SDL_SCANCODE_KP_EQUALSAS400 };

    /// Used on Asian keyboards, see footnotes in USB doc.
    pub const international1 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL1 };
    pub const international2 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL2 };

    /// Yen.
    pub const international3 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL3 };
    pub const international4 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL4 };
    pub const international5 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL5 };
    pub const international6 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL6 };
    pub const international7 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL7 };
    pub const international8 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL8 };
    pub const international9 = Scancode{ .value = C.SDL_SCANCODE_INTERNATIONAL9 };

    /// Hangul/English toggle.
    pub const lang1 = Scancode{ .value = C.SDL_SCANCODE_LANG1 };

    /// Hanja conversion.
    pub const lang2 = Scancode{ .value = C.SDL_SCANCODE_LANG2 };

    /// Katakana.
    pub const lang3 = Scancode{ .value = C.SDL_SCANCODE_LANG3 };

    /// Hiragana.
    pub const lang4 = Scancode{ .value = C.SDL_SCANCODE_LANG4 };

    /// Zenkaku/Hankaku.
    pub const lang5 = Scancode{ .value = C.SDL_SCANCODE_LANG5 };

    /// Reserved.
    pub const lang6 = Scancode{ .value = C.SDL_SCANCODE_LANG6 };

    /// Reserved.
    pub const lang7 = Scancode{ .value = C.SDL_SCANCODE_LANG7 };

    /// Reserved.
    pub const lang8 = Scancode{ .value = C.SDL_SCANCODE_LANG8 };

    /// Reserved.
    pub const lang9 = Scancode{ .value = C.SDL_SCANCODE_LANG9 };

    /// Erase-Eaze.
    pub const alterase = Scancode{ .value = C.SDL_SCANCODE_ALTERASE };
    pub const sysreq = Scancode{ .value = C.SDL_SCANCODE_SYSREQ };

    /// AC Cancel.
    pub const cancel = Scancode{ .value = C.SDL_SCANCODE_CANCEL };
    pub const clear = Scancode{ .value = C.SDL_SCANCODE_CLEAR };
    pub const prior = Scancode{ .value = C.SDL_SCANCODE_PRIOR };
    pub const return2 = Scancode{ .value = C.SDL_SCANCODE_RETURN2 };
    pub const separator = Scancode{ .value = C.SDL_SCANCODE_SEPARATOR };
    pub const out = Scancode{ .value = C.SDL_SCANCODE_OUT };
    pub const oper = Scancode{ .value = C.SDL_SCANCODE_OPER };
    pub const clearagain = Scancode{ .value = C.SDL_SCANCODE_CLEARAGAIN };
    pub const crsel = Scancode{ .value = C.SDL_SCANCODE_CRSEL };
    pub const exsel = Scancode{ .value = C.SDL_SCANCODE_EXSEL };
    pub const kp_00 = Scancode{ .value = C.SDL_SCANCODE_KP_00 };
    pub const kp_000 = Scancode{ .value = C.SDL_SCANCODE_KP_000 };
    pub const thousandsseparator = Scancode{ .value = C.SDL_SCANCODE_THOUSANDSSEPARATOR };
    pub const decimalseparator = Scancode{ .value = C.SDL_SCANCODE_DECIMALSEPARATOR };
    pub const currencyunit = Scancode{ .value = C.SDL_SCANCODE_CURRENCYUNIT };
    pub const currencysubunit = Scancode{ .value = C.SDL_SCANCODE_CURRENCYSUBUNIT };
    pub const kp_leftparen = Scancode{ .value = C.SDL_SCANCODE_KP_LEFTPAREN };
    pub const kp_rightparen = Scancode{ .value = C.SDL_SCANCODE_KP_RIGHTPAREN };
    pub const kp_leftbrace = Scancode{ .value = C.SDL_SCANCODE_KP_LEFTBRACE };
    pub const kp_rightbrace = Scancode{ .value = C.SDL_SCANCODE_KP_RIGHTBRACE };
    pub const kp_tab = Scancode{ .value = C.SDL_SCANCODE_KP_TAB };
    pub const kp_backspace = Scancode{ .value = C.SDL_SCANCODE_KP_BACKSPACE };
    pub const kp_a = Scancode{ .value = C.SDL_SCANCODE_KP_A };
    pub const kp_b = Scancode{ .value = C.SDL_SCANCODE_KP_B };
    pub const kp_c = Scancode{ .value = C.SDL_SCANCODE_KP_C };
    pub const kp_d = Scancode{ .value = C.SDL_SCANCODE_KP_D };
    pub const kp_e = Scancode{ .value = C.SDL_SCANCODE_KP_E };
    pub const kp_f = Scancode{ .value = C.SDL_SCANCODE_KP_F };
    pub const kp_xor = Scancode{ .value = C.SDL_SCANCODE_KP_XOR };
    pub const kp_power = Scancode{ .value = C.SDL_SCANCODE_KP_POWER };
    pub const kp_percent = Scancode{ .value = C.SDL_SCANCODE_KP_PERCENT };
    pub const kp_less = Scancode{ .value = C.SDL_SCANCODE_KP_LESS };
    pub const kp_greater = Scancode{ .value = C.SDL_SCANCODE_KP_GREATER };
    pub const kp_ampersand = Scancode{ .value = C.SDL_SCANCODE_KP_AMPERSAND };
    pub const kp_dblampersand = Scancode{ .value = C.SDL_SCANCODE_KP_DBLAMPERSAND };
    pub const kp_verticalbar = Scancode{ .value = C.SDL_SCANCODE_KP_VERTICALBAR };
    pub const kp_dblverticalbar = Scancode{ .value = C.SDL_SCANCODE_KP_DBLVERTICALBAR };
    pub const kp_colon = Scancode{ .value = C.SDL_SCANCODE_KP_COLON };
    pub const kp_hash = Scancode{ .value = C.SDL_SCANCODE_KP_HASH };
    pub const kp_space = Scancode{ .value = C.SDL_SCANCODE_KP_SPACE };
    pub const kp_at = Scancode{ .value = C.SDL_SCANCODE_KP_AT };
    pub const kp_exclam = Scancode{ .value = C.SDL_SCANCODE_KP_EXCLAM };
    pub const kp_memstore = Scancode{ .value = C.SDL_SCANCODE_KP_MEMSTORE };
    pub const kp_memrecall = Scancode{ .value = C.SDL_SCANCODE_KP_MEMRECALL };
    pub const kp_memclear = Scancode{ .value = C.SDL_SCANCODE_KP_MEMCLEAR };
    pub const kp_memadd = Scancode{ .value = C.SDL_SCANCODE_KP_MEMADD };
    pub const kp_memsubtract = Scancode{ .value = C.SDL_SCANCODE_KP_MEMSUBTRACT };
    pub const kp_memmultiply = Scancode{ .value = C.SDL_SCANCODE_KP_MEMMULTIPLY };
    pub const kp_memdivide = Scancode{ .value = C.SDL_SCANCODE_KP_MEMDIVIDE };
    pub const kp_plusminus = Scancode{ .value = C.SDL_SCANCODE_KP_PLUSMINUS };
    pub const kp_clear = Scancode{ .value = C.SDL_SCANCODE_KP_CLEAR };
    pub const kp_clearentry = Scancode{ .value = C.SDL_SCANCODE_KP_CLEARENTRY };
    pub const kp_binary = Scancode{ .value = C.SDL_SCANCODE_KP_BINARY };
    pub const kp_octal = Scancode{ .value = C.SDL_SCANCODE_KP_OCTAL };
    pub const kp_decimal = Scancode{ .value = C.SDL_SCANCODE_KP_DECIMAL };
    pub const kp_hexadecimal = Scancode{ .value = C.SDL_SCANCODE_KP_HEXADECIMAL };
    pub const lctrl = Scancode{ .value = C.SDL_SCANCODE_LCTRL };
    pub const lshift = Scancode{ .value = C.SDL_SCANCODE_LSHIFT };

    /// Alt, option.
    pub const lalt = Scancode{ .value = C.SDL_SCANCODE_LALT };

    /// Windows, command (apple), meta.
    pub const lgui = Scancode{ .value = C.SDL_SCANCODE_LGUI };
    pub const rctrl = Scancode{ .value = C.SDL_SCANCODE_RCTRL };
    pub const rshift = Scancode{ .value = C.SDL_SCANCODE_RSHIFT };

    /// Alt gr, option.
    pub const ralt = Scancode{ .value = C.SDL_SCANCODE_RALT };

    /// Windows, command (apple), meta.
    pub const rgui = Scancode{ .value = C.SDL_SCANCODE_RGUI };

    /// I'm not sure if this is really not covered by any of the above, but since there's a special `keycode.KeyModifier.mode` for it I'm adding it here.
    pub const mode = Scancode{ .value = C.SDL_SCANCODE_MODE };

    /// Sleep.
    pub const sleep = Scancode{ .value = C.SDL_SCANCODE_SLEEP };

    /// Wake.
    pub const wake = Scancode{ .value = C.SDL_SCANCODE_WAKE };

    /// Channel increment.
    pub const channel_increment = Scancode{ .value = C.SDL_SCANCODE_CHANNEL_INCREMENT };

    /// Channel decrement.
    pub const channel_decrement = Scancode{ .value = C.SDL_SCANCODE_CHANNEL_DECREMENT };

    /// Play.
    pub const media_play = Scancode{ .value = C.SDL_SCANCODE_MEDIA_PLAY };

    /// Pause.
    pub const media_pause = Scancode{ .value = C.SDL_SCANCODE_MEDIA_PAUSE };

    /// Record.
    pub const media_record = Scancode{ .value = C.SDL_SCANCODE_MEDIA_RECORD };

    /// Fast forward.
    pub const media_fast_forward = Scancode{ .value = C.SDL_SCANCODE_MEDIA_FAST_FORWARD };

    /// Rewind.
    pub const media_rewind = Scancode{ .value = C.SDL_SCANCODE_MEDIA_REWIND };

    /// Next track.
    pub const media_next_track = Scancode{ .value = C.SDL_SCANCODE_MEDIA_NEXT_TRACK };

    /// Previous track.
    pub const media_previous_track = Scancode{ .value = C.SDL_SCANCODE_MEDIA_PREVIOUS_TRACK };

    /// Stop.
    pub const media_stop = Scancode{ .value = C.SDL_SCANCODE_MEDIA_STOP };

    /// Eject.
    pub const media_eject = Scancode{ .value = C.SDL_SCANCODE_MEDIA_EJECT };

    /// Play/pause.
    pub const media_play_pause = Scancode{ .value = C.SDL_SCANCODE_MEDIA_PLAY_PAUSE };

    /// Media select.
    pub const media_select = Scancode{ .value = C.SDL_SCANCODE_MEDIA_SELECT };

    /// AC New.
    pub const ac_new = Scancode{ .value = C.SDL_SCANCODE_AC_NEW };

    /// AC Open.
    pub const ac_open = Scancode{ .value = C.SDL_SCANCODE_AC_OPEN };

    /// AC Close.
    pub const ac_close = Scancode{ .value = C.SDL_SCANCODE_AC_CLOSE };

    /// AC Exist.
    pub const ac_exit = Scancode{ .value = C.SDL_SCANCODE_AC_EXIT };

    /// AC Save.
    pub const ac_save = Scancode{ .value = C.SDL_SCANCODE_AC_SAVE };

    /// AC Print.
    pub const ac_print = Scancode{ .value = C.SDL_SCANCODE_AC_PRINT };

    /// AC Properties.
    pub const ac_properties = Scancode{ .value = C.SDL_SCANCODE_AC_PROPERTIES };

    /// AC Search.
    pub const ac_search = Scancode{ .value = C.SDL_SCANCODE_AC_SEARCH };

    /// AC Home.
    pub const ac_home = Scancode{ .value = C.SDL_SCANCODE_AC_HOME };

    /// AC Back.
    pub const ac_back = Scancode{ .value = C.SDL_SCANCODE_AC_BACK };

    /// AC Forward.
    pub const ac_forward = Scancode{ .value = C.SDL_SCANCODE_AC_FORWARD };

    /// AC Stop.
    pub const ac_stop = Scancode{ .value = C.SDL_SCANCODE_AC_STOP };

    /// AC Refresh.
    pub const ac_refresh = Scancode{ .value = C.SDL_SCANCODE_AC_REFRESH };

    /// AC Bookmarks.
    pub const ac_bookmarks = Scancode{ .value = C.SDL_SCANCODE_AC_BOOKMARKS };

    /// Usually situated below the display on phones and used as a multi-function feature key for selecting a software defined function shown on the bottom left of the display.
    pub const softleft = Scancode{ .value = C.SDL_SCANCODE_SOFTLEFT };

    /// Usually situated below the display on phones and used as a multi-function feature key for selecting a software defined function shown on the bottom right of the display.
    pub const softright = Scancode{ .value = C.SDL_SCANCODE_SOFTRIGHT };

    /// Used for accepting phone calls.
    pub const call = Scancode{ .value = C.SDL_SCANCODE_CALL };

    /// Used for rejecting phone calls.
    pub const endcall = Scancode{ .value = C.SDL_SCANCODE_ENDCALL };

    /// Reserved for dynamic keycodes.
    pub const reserved_start = Scancode{ .value = C.SDL_SCANCODE_RESERVED_START };

    /// If the scancode matches another.
    pub fn matches(self: Scancode, other: Scancode) bool {
        return self.value == other.value;
    }
};

// Simple scancode test.
test "Scancode" {
    try std.testing.expect(Scancode.g.matches(Scancode{ .value = C.SDL_SCANCODE_G }));
}
