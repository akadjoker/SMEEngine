unit SDL2_Image;
{*******************************************************************************

  SDL2_Image.pas  v1.0  29/07/2013

  Simple DirectMedia Layer
  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>

  Pascal-Header-Conversion SDL from the JEDI-Team written by Domenique Louis and others.

  convert SDL to SDL2 by Kotai 2013  www.remakesonline.com

  The initial developer of this Pascal code was :
  Dominqiue Louis <Dominique@SavageSoftware.com.au>


*******************************************************************************}

{$I sdl2.inc}

interface

uses

  sdl2;

const


 {$IFDEF  MSWINDOWS		}
  SDL_ImageLibName = 'SDLSimple.dll';
  {$ELSE}
  SDL_ImageLibName = 'libSDL_Simple.so';
  {$ENDIF}



  // Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL
  SDL_IMAGE_MAJOR_VERSION = 2;
{$EXTERNALSYM SDL_IMAGE_MAJOR_VERSION}
  SDL_IMAGE_MINOR_VERSION = 0;
{$EXTERNALSYM SDL_IMAGE_MINOR_VERSION}
  SDL_IMAGE_PATCHLEVEL    = 0;
{$EXTERNALSYM SDL_IMAGE_PATCHLEVEL}

{ This macro can be used to fill a version structure with the compile-time
  version of the SDL_image library. }
procedure SDL_IMAGE_VERSION( var X : TSDL_Version );
{$EXTERNALSYM SDL_IMAGE_VERSION}

{ This function gets the version of the dynamically linked SDL_image library.
   it should NOT be used to fill a version structure, instead you should
   use the SDL_IMAGE_VERSION() macro.
 }
function IMG_Linked_Version : PSDL_version;
external {$IFDEF __GPC__}name 'IMG_Linked_Version'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_Linked_Version}

{ Load an image from an SDL data source.
   The 'type' may be one of: "BMP", "GIF", "PNG", etc.

   If the image format supports a transparent pixel, SDL will set the
   colorkey for the surface.  You can enable RLE acceleration on the
   surface afterwards by calling:
        SDL_SetColorKey(image, SDL_RLEACCEL, image.format.colorkey);
}
function IMG_LoadTyped_RW(src: PSDL_RWops; freesrc: Integer; _type: PAnsiChar): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadTyped_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadTyped_RW}
{ Convenience functions }
function IMG_Load(const _file: PAnsiChar): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_Load'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_Load}
function IMG_Load_RW(src: PSDL_RWops; freesrc: Integer): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_Load_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_Load_RW}

{ Invert the alpha of a surface for use with OpenGL
  This function is now a no-op, and only provided for backwards compatibility. }
function IMG_InvertAlpha(_on: Integer): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_InvertAlpha'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_InvertAlpha}

{ Functions to detect a file type, given a seekable source }
function IMG_isBMP(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isBMP'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isBMP}

function IMG_isGIF(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isGIF'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isGIF}

function IMG_isJPG(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isJPG'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isJPG}

function IMG_isLBM(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isLBM'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isLBM}

function IMG_isPCX(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isPCX'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isPCX}

function IMG_isPNG(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isPNG'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isPNG}

function IMG_isPNM(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isPNM'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isPNM}

function IMG_isTIF(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isTIF'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isTIF}

function IMG_isXCF(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isXCF'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isXCF}

function IMG_isXPM(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isXPM'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isXPM}

function IMG_isXV(src: PSDL_RWops): Integer;
cdecl; external {$IFDEF __GPC__}name 'IMG_isXV'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_isXV}


{ Individual loading functions }
function IMG_LoadBMP_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadBMP_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadBMP_RW}

function IMG_LoadGIF_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadGIF_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadGIF_RW}

function IMG_LoadJPG_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadJPG_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadJPG_RW}

function IMG_LoadLBM_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadLBM_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadLBM_RW}

function IMG_LoadPCX_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadPCX_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadPCX_RW}

function IMG_LoadPNM_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadPNM_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadPNM_RW}

function IMG_LoadPNG_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadPNG_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadPNG_RW}

function IMG_LoadTGA_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadTGA_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadTGA_RW}

function IMG_LoadTIF_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadTIF_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadTIF_RW}

function IMG_LoadXCF_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadXCF_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadXCF_RW}

function IMG_LoadXPM_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadXPM_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadXPM_RW}

function IMG_LoadXV_RW(src: PSDL_RWops): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_LoadXV_RW'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_LoadXV_RW}

function IMG_ReadXPMFromArray( xpm : PAnsiChar ): PSDL_Surface;
cdecl; external {$IFDEF __GPC__}name 'IMG_ReadXPMFromArray'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
{$EXTERNALSYM IMG_ReadXPMFromArray}



function IMG_SavePNG(surface:PSDL_Surface; const fileName:pchar): Integer;cdecl; external   SDL_ImageLibName name 'IMG_SavePNG';
function IMG_SavePNG_RW(surface:PSDL_Surface;dst:PSDL_RWops;freedst:integer): Integer;cdecl; external   SDL_ImageLibName name 'IMG_SavePNG_RW';



function IMG_LoadTextureTyped_RW(renderer:PSDL_Renderer;src: PSDL_RWops; freesrc: Integer; _type: PAnsiChar): PSDL_Texture;cdecl; external  SDL_ImageLibName name 'IMG_LoadTextureTyped_RW';

function IMG_LoadTexture(renderer:PSDL_Renderer;const _file: PAnsiChar): PSDL_Texture;cdecl; external  SDL_ImageLibName name 'IMG_LoadTexture' ;

function IMG_LoadTexture_RW(renderer:PSDL_Renderer;src: PSDL_RWops; freesrc: Integer): PSDL_Texture;cdecl; external SDL_ImageLibName name 'IMG_Load_RW' ;



{ used internally, NOT an exported function }
//function IMG_string_equals( const str1 : PAnsiChar; const str2 : PAnsiChar ) : integer;
//cdecl; external {$IFDEF __GPC__}name 'IMG_string_equals'{$ELSE} SDL_ImageLibName{$ENDIF __GPC__};
//{ $ EXTERNALSYM IMG_string_equals}

{ Error Macros }
{ We'll use SDL for reporting errors }
procedure IMG_SetError( fmt : PAnsiChar );

function IMG_GetError : PAnsiChar;

implementation

{$IFDEF __GPC__}
  {$L 'sdl_image'}  { link sdl_image.dll.a or libsdl_image.so or libsdl_image.a }
{$ENDIF}

procedure SDL_IMAGE_VERSION( var X : TSDL_Version );
begin
  X.major := SDL_IMAGE_MAJOR_VERSION;
  X.minor := SDL_IMAGE_MINOR_VERSION;
  X.patch := SDL_IMAGE_PATCHLEVEL;
end;

procedure IMG_SetError( fmt : PAnsiChar );
begin
  SDL_SetError( fmt );
end;

function IMG_GetError : PAnsiChar;
begin
  result := SDL_GetError;
end;

end.
