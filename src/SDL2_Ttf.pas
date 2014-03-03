unit SDL2_Ttf;
{*******************************************************************************

  SDL2_Ttf.pas  v1.0  29/07/2013

  Simple DirectMedia Layer
  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>

  Pascal-Header-Conversion SDL from the JEDI-Team written by Domenique Louis and others.

  convert SDL to SDL2 by Kotai 2013  www.remakesonline.com

  The initial developer of this Pascal code was :
  Dominqiue Louis <Dominique@SavageSoftware.com.au>


*******************************************************************************}

{$I sdl2.inc}

{$IFDEF UNIX}
{$DEFINE Workaround_TTF_RenderText_Solid}
{$ENDIF}


interface

uses



  sdl2;

const

{$IFDEF  MSWINDOWS		}
  SDLttfLibName = 'SDLSimple.dll';
  {$ELSE}
  SDLttfLibName = 'libSDL_Simple.so';
  {$ENDIF}






  {* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL *}
  SDL_TTF_MAJOR_VERSION = 2;
{$EXTERNALSYM SDL_TTF_MAJOR_VERSION}
  SDL_TTF_MINOR_VERSION = 0;
{$EXTERNALSYM SDL_TTF_MINOR_VERSION}
  SDL_TTF_PATCHLEVEL = 9;
{$EXTERNALSYM SDL_TTF_PATCHLEVEL}

  // Backwards compatibility
  TTF_MAJOR_VERSION = SDL_TTF_MAJOR_VERSION;
  TTF_MINOR_VERSION = SDL_TTF_MINOR_VERSION;
  TTF_PATCHLEVEL    = SDL_TTF_PATCHLEVEL;

{*
   Set and retrieve the font style
   This font style is implemented by modifying the font glyphs, and
   doesn't reflect any inherent properties of the truetype font file.
*}
  TTF_STYLE_NORMAL	  = $00;
  TTF_STYLE_BOLD      = $01;
  TTF_STYLE_ITALIC	  = $02;
  TTF_STYLE_UNDERLINE	= $04;

// ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark)
  UNICODE_BOM_NATIVE  = $FEFF;
  UNICODE_BOM_SWAPPED = $FFFE;

type
  PTTF_Font = ^TTTF_font;
  TTTF_Font = record
  end;

{ This macro can be used to fill a version structure with the compile-time
  version of the SDL_ttf library. }
procedure SDL_TTF_VERSION( var X : TSDL_version );
{$EXTERNALSYM SDL_TTF_VERSION}

{ This function gets the version of the dynamically linked SDL_ttf library.
     It should NOT be used to fill a version structure, instead you should use the
     SDL_TTF_VERSION() macro. }
function TTF_Linked_Version : PSDL_version;
cdecl; external {$IFDEF __GPC__}name 'TTF_Linked_Version'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_Linked_Version}

{ This function tells the library whether UNICODE text is generally
   byteswapped.  A UNICODE BOM character in a string will override
   this setting for the remainder of that string.
}
procedure TTF_ByteSwappedUNICODE( swapped : integer );
cdecl; external {$IFDEF __GPC__}name 'TTF_ByteSwappedUNICODE'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_ByteSwappedUNICODE}

//returns 0 on succes, -1 if error occurs
function TTF_Init : integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_Init'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_Init}

{
 Open a font file and create a font of the specified point size.
 Some .fon fonts will have several sizes embedded in the file, so the
 point size becomes the index of choosing which size.  If the value
 is too high, the last indexed size will be the default.
}
function TTF_OpenFont( const filename : PChar; ptsize : integer ) : PTTF_Font;
cdecl; external {$IFDEF __GPC__}name 'TTF_OpenFont'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_OpenFont}

function TTF_OpenFontIndex( const filename : PChar; ptsize : integer; index : Longint ): PTTF_Font;
cdecl; external {$IFDEF __GPC__}name 'TTF_OpenFontIndex'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_OpenFontIndex}

function TTF_OpenFontRW( src : PSDL_RWops; freesrc : integer; ptsize : integer ): PTTF_Font;
cdecl; external {$IFDEF __GPC__}name 'TTF_OpenFontRW'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_OpenFontRW}

function TTF_OpenFontIndexRW( src : PSDL_RWops; freesrc : integer; ptsize : integer; index : Longint ): PTTF_Font;
cdecl; external {$IFDEF __GPC__}name 'TTF_OpenFontIndexRW'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_OpenFontIndexRW}

function TTF_GetFontStyle( font : PTTF_Font) : integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_GetFontStyle'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_GetFontStyle}

procedure TTF_SetFontStyle( font : PTTF_Font; style : integer );
cdecl; external {$IFDEF __GPC__}name 'TTF_SetFontStyle'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_SetFontStyle}

{ Get the total height of the font - usually equal to point size }
function TTF_FontHeight( font : PTTF_Font ) : Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontHeight'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontHeight}

{ Get the offset from the baseline to the top of the font
   This is a positive value, relative to the baseline.
}
function TTF_FontAscent( font : PTTF_Font ) : Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontAscent'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontAscent}
{ Get the offset from the baseline to the bottom of the font
   This is a negative value, relative to the baseline.
}
function TTF_FontDescent( font : PTTF_Font ) : Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontDescent'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontDescent}

{ Get the recommended spacing between lines of text for this font }
function TTF_FontLineSkip( font : PTTF_Font ): Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontLineSkip'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontLineSkip}

{ Get the number of faces of the font }
function TTF_FontFaces( font : PTTF_Font ) : Longint;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontFaces'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontFaces}

{ Get the font face attributes, if any }
function TTF_FontFaceIsFixedWidth( font : PTTF_Font ): Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontFaceIsFixedWidth'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontFaceIsFixedWidth}

function TTF_FontFaceFamilyName( font : PTTF_Font ): PChar;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontFaceFamilyName'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontFaceFamilyName}

function TTF_FontFaceStyleName( font : PTTF_Font ): PChar;
cdecl; external {$IFDEF __GPC__}name 'TTF_FontFaceStyleName'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_FontFaceStyleName}

{ Get the metrics (dimensions) of a glyph }
function TTF_GlyphMetrics( font : PTTF_Font; ch : Uint16;
                            var minx : integer; var maxx : integer;
                            var miny : integer; var maxy : integer;
                            var advance : integer ): Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_GlyphMetrics'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_GlyphMetrics}

{ Get the dimensions of a rendered string of text }
function TTF_SizeText( font : PTTF_Font; const text : PChar; var w : integer; var y : integer ): Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_SizeText'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_SizeText}

function TTF_SizeUTF8( font : PTTF_Font; const text : PChar; var w : integer; var y : integer): Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_SizeUTF8'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_SizeUTF8}

function TTF_SizeUNICODE( font : PTTF_Font; const text : PUint16; var w : integer; var y : integer): Integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_SizeUNICODE'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_SizeUNICODE}

{ Create an 8-bit palettized surface and render the given text at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.
   This function returns the new surface, or NULL if there was an error.
}
function TTF_RenderText_Solid( font : PTTF_Font;
				const text : PChar; fg : TSDL_Color ): PSDL_Surface;
{$IFNDEF Workaround_TTF_RenderText_Solid}
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderText_Solid'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderText_Solid}
{$ENDIF}

function TTF_RenderUTF8_Solid( font : PTTF_Font;
				const text : PChar; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderUTF8_Solid'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderUTF8_Solid}

function TTF_RenderUNICODE_Solid( font : PTTF_Font;
				const text :PUint16; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderUNICODE_Solid'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderUNICODE_Solid}

{
Create an 8-bit palettized surface and render the given glyph at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.  The glyph is rendered without any padding or
   centering in the X direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
}
function  TTF_RenderGlyph_Solid( font : PTTF_Font;
					ch : Uint16; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderGlyph_Solid'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderGlyph_Solid}

{ Create an 8-bit palettized surface and render the given text at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   This function returns the new surface, or NULL if there was an error.
}
function TTF_RenderText_Shaded( font : PTTF_Font;
				const text : PChar; fg : TSDL_Color; bg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderText_Shaded'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderText_Shaded}
function TTF_RenderUTF8_Shaded( font : PTTF_Font;
				const text : PChar; fg : TSDL_Color; bg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderUTF8_Shaded'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderUTF8_Shaded}
function TTF_RenderUNICODE_Shaded( font : PTTF_Font;
				const text : PUint16; fg : TSDL_Color; bg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderUNICODE_Shaded'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderUNICODE_Shaded}

{ Create an 8-bit palettized surface and render the given glyph at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
}
function  TTF_RenderGlyph_Shaded( font : PTTF_Font; ch : Uint16; fg : TSDL_Color;
                                  bg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderGlyph_Shaded'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderGlyph_Shaded}

{ Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   This function returns the new surface, or NULL if there was an error.
}
function TTF_RenderText_Blended( font : PTTF_Font;
				const text : PChar; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderText_Blended'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderText_Blended}
function TTF_RenderUTF8_Blended( font : PTTF_Font;
				const text : PChar; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderUTF8_Blended'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderUTF8_Blended}
function TTF_RenderUNICODE_Blended( font : PTTF_Font;
				const text: PUint16; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderUNICODE_Blended'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderUNICODE_Blended}

{ Create a 32-bit ARGB surface and render the given glyph at high quality,
   using alpha blending to dither the font with the given color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
}
function  TTF_RenderGlyph_Blended( font : PTTF_Font; ch : Uint16; fg : TSDL_Color ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'TTF_RenderGlyph_Blended'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_RenderGlyph_Blended}

{ For compatibility with previous versions, here are the old functions }
{#define TTF_RenderText(font, text, fg, bg)
	TTF_RenderText_Shaded(font, text, fg, bg)
#define TTF_RenderUTF8(font, text, fg, bg)	
	TTF_RenderUTF8_Shaded(font, text, fg, bg)
#define TTF_RenderUNICODE(font, text, fg, bg)	
	TTF_RenderUNICODE_Shaded(font, text, fg, bg)}

{ Close an opened font file }
procedure TTF_CloseFont( font : PTTF_Font );
cdecl; external {$IFDEF __GPC__}name 'TTF_CloseFont'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_CloseFont}

//De-initialize TTF engine
procedure TTF_Quit;
cdecl; external {$IFDEF __GPC__}name 'TTF_Quit'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_Quit}

// Check if the TTF engine is initialized
function TTF_WasInit : integer;
cdecl; external {$IFDEF __GPC__}name 'TTF_WasInit'{$ELSE} SDLttfLibName{$ENDIF __GPC__};
{$EXTERNALSYM TTF_WasInit}

// We'll use SDL for reporting errors
procedure TTF_SetError( fmt : PAnsiChar );

function TTF_GetError : PAnsiChar;

implementation

{$IFDEF __GPC__}
  {$L 'sdl_ttf'}  { link sdl_ttf.dll.a or libsdl_ttf.so or libsdl_ttf.a }
{$ENDIF}

procedure SDL_TTF_VERSION( var X : TSDL_version );
begin
  X.major := SDL_TTF_MAJOR_VERSION;
  X.minor := SDL_TTF_MINOR_VERSION;
  X.patch := SDL_TTF_PATCHLEVEL;
end;

procedure TTF_SetError( fmt : PAnsiChar );
begin
  SDL_SetError( fmt );
end;

function TTF_GetError : PAnsiChar;
begin
  result := SDL_GetError;
end;

{$IFDEF Workaround_TTF_RenderText_Solid}
function TTF_RenderText_Solid( font : PTTF_Font;
  const text : PChar; fg : TSDL_Color ): PSDL_Surface;
const
  Black: TSDL_Color = (r: 0; g: 0; b: 0; unused: 0);
begin
  Result := TTF_RenderText_Shaded(font, text, fg, Black);
end;
{$ENDIF Workaround_TTF_RenderText_Solid}

end.
