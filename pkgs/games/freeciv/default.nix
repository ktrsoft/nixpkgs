{ stdenv, fetchurl, zlib, bzip2, pkgconfig, curl, lzma, gettext
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype, fluidsynth
, gtkClient ? false, gtk2
, server ? true, readline }:

let
  inherit (stdenv.lib) optional optionals;

  sdlName = if sdlClient then "-sdl" else "";
  gtkName = if gtkClient then "-gtk" else "";

  name = "freeciv";
  version = "2.5.6";
in
stdenv.mkDerivation {
  name = "${name}${sdlName}${gtkName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freeciv/${name}-${version}.tar.bz2";
    sha256 = "16wrnsx5rmbz6rjs03bhy0vn20i6n6g73lx7fjpai98ixhzc5bfg";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib bzip2 curl lzma gettext ]
    ++ optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype fluidsynth ]
    ++ optionals gtkClient [ gtk2 ]
    ++ optional server readline;

  configureFlags = []
    ++ optional sdlClient "--enable-client=sdl"
    ++ optional (!gtkClient) "--enable-fcmp=cli"
    ++ optional (!server) "--disable-server";

  meta = with stdenv.lib; {
    description = "Multiplayer (or single player), turn-based strategy game";

    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';

    homepage = http://freeciv.wikia.com/;
    license = licenses.gpl2;

    maintainers = with maintainers; [ pierron ];
    platforms = platforms.linux;
  };
}
