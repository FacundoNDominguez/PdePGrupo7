/*

 _____         _ _            _____ _         _
|   __|___ ___|_| |___ ___   |  _  | |___ ___| |_
|__   | . | . | | | -_|  _|  |     | | -_|  _|  _|
|_____|  _|___|_|_|___|_|    |__|__|_|___|_| |_|
      |_|

 */

%1 Punto A: Quién Mira Qué.

serie(Serie):- mira(_,Serie).

persona(Persona):- mira(Persona,_).

%mira(persona,serie).

mira(juan,himym).
mira(juan,futurama).
mira(juan,got).
mira(nico,starWars).
mira(nico,got).
mira(maiu,onePiece).
mira(maiu,got).
mira(gaston,hoc).
mira(gaston,starWars).

mira(pedro,got).

% No se pone en la base de conocimiento que Alf no mira ninguna serie por el principio de universo cerrado.

%esPopular(serie).

esPopular(got).
esPopular(futurama).
esPopular(starWars).

%planeaVer(persona,serie).

planeaVer(juan,hoc).
planeaVer(aye,got).
planeaVer(gaston,himym).


%cantidadDeEpisodios(serie,temporada,episodios).

cantidadDeEpisodios(got,3,12).
cantidadDeEpisodios(got,2,10).
cantidadDeEpisodios(himym,1,23).
cantidadDeEpisodios(drHouse,8,16).

%No se pone en la base de conocimiento la cantidad de episodios que tiene la segunda temporada de "Mad Men" por el principio de universo cerrado

%2 Anexo: Lo que pasó, pasó.

%paso(Serie, Temporada, Episodio, Lo que paso).

paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

%leDijo(persona,persona,serie,paso).

leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

leDijo(nico, juan, futurama, muerte(seymourDiera)).
leDijo(pedro,aye,got,relacion(amistad, tyrion, dragon)).
leDijo(pedro,nico,got,relacion(parentesco, tyrion, dragon)).

%3 Punto B: Es Spoiler.

esSpoiler(Serie,Spoiler):- paso(Serie,_,_,Spoiler).

%El tipo de consulta que se puede hacer a esta base de conocimientos es existencial ya que puede realizar la consulta por cualquier variable.

%4 Punto C: Te pedí que no me lo dijeras.

leSpoileo(Persona , Persona2, Serie):-
    leDijo(Persona, Persona2, Serie, Spoiler),
    esSpoiler(Serie,Spoiler),						%con esto verifico si lo que le dijo es un espoiler, depues veo si le importa o no.
    planeaVerOMiraSerie(Persona2, Serie).

planeaVerOMiraSerie(Persona,Serie):- planeaVer(Persona, Serie).
planeaVerOMiraSerie(Persona,Serie):- mira(Persona, Serie).


%5 Punto D: Responsable.

televidenteResponsable(Persona):- %Hay que mejorarlo. No funciona bien.
%Miren como use el not ahi, esta bien Fresh.
  persona(Persona),
  not(leSpoileo(Persona,_,_)).

%6 Punto E: Viene Zafando.

vieneZafando(Persona, Serie):-
		planeaVerOMiraSerie(Persona,Serie),
		seriePopularOConHechosFuertes(Serie),
		not(leSpoileo(_,Persona, Serie)).


seriePopularOConHechosFuertes(Serie):- esPopular(Serie).
seriePopularOConHechosFuertes(Serie):- pasoCosasFuertesEnSusTemporadas(Serie).

pasoCosasFuertesEnSusTemporadas(Serie):-
        cantidadDeEpisodios(Serie, _, _),
        forall(cantidadDeEpisodios(Serie, Temporada,_),sucesoFuerteTemporada(Serie, Temporada)).

sucesoFuerteTemporada(Serie,Temporada):-paso(Serie,Temporada,_,muerte(_)).
sucesoFuerteTemporada(Serie,Temporada):-paso(Serie,Temporada,_,relacion(parentesco,_,_)).
sucesoFuerteTemporada(Serie,Temporada):-paso(Serie,Temporada,_,relacion(amorosa,_,_)).


% Tests

:- begin_tests(series).

test(esEspoilerPAraStarWars, nondet):-
		esSpoiler(starWars,muerte(emperor)).

test(esEspoilerPAraStarWars, nondet):-
		esSpoiler(starWars,relacion(parentesco,anakin,rey)).

test(noEsSpoilerDeStarWars, nondet):-
		not(esSpoiler(starWars,relacion(parentesco,anakin,lavezzi))).

test(gastonSpoileoAMaiuSobreGot, nondet):-
		leSpoileo(gaston,maiu,got).

test(nicoSpoileoAMaiuSobreStarWarsPeroAMaiuNoLeInteresa, nondet):-
		not(leSpoileo(nico,maiu,starWars)).

test(juanVieneZafandoConHIMYM, nondet):-
		vieneZafando(juan,himym).

test(juanVieneZafandoConGot, nondet):-
		vieneZafando(juan,got).

test(juanNoVieneZafandoConFuturama, nondet):-
		not(vieneZafando(juan,futurama)).

test(juanVieneZafandoConHoc, nondet):-
		vieneZafando(juan,hoc).

test(soloNicoVieneZafandoConStarWars, nondet):-
		vieneZafando(Persona,starWars),
		not(Persona \= nico).

test(gastonEsMalaGente, nondet):-
		malaGente(gaston).

test(nicoEsMalaGente, nondet):-
		malaGente(nico).

test(pedroNoEsMalaGente, nondet):-
		not(malaGente(pedro)).

:- end_tests(series).


% PARTE 2

malaGente(Persona):-
    leDijo(Persona,_,_,_),
    forall(leDijo(Persona,Victima,_,_),leSpoileo(Persona, Victima,_)).

malaGente(Persona):-
    leSpoileo(Persona,_,Serie),
    not(mira(Persona, Serie)).

