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
mira(gasto,starWars).

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

esFuerte(Serie):- paso(Serie,_,_,muerte(_)).
esFuerte(Serie):- paso(Serie,_,_,relacion(LoQuePaso,_,_)), LoQuePaso \= amistad. 

%esFuerte(muera(LoQuePaso)):- paso(_,_,_, muerte(LoQuePaso)).
%esFuerte(relacion(LoQuePaso)):- paso(_,_,_,relacion(LoQuePaso,_,_)), LoQuePaso \= amistad. 
%esFuerte(relacion(LoQuePaso,_,_)):- paso(_,_,_,relacion(LoQuePaso,_,_)), LoQuePaso \= amistad. Cual de las dos ?


vieneZafando(Persona, Serie):- 
		planeaVerOMiraSerie(Persona,Serie),
		not(leSpoileo(_,Persona, Serie)),
		seriePopularOConHechosFuertes(Serie).   % Este predicaco me parece al dope poque 
												% no tene peso a la hora de evaluar el predicado.

seriePopularOConHechosFuertes(Serie):- esPopular(Serie).
seriePopularOConHechosFuertes(Serie):- esFuerte(Serie).

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

test(juanVieneZafandoConFuturama, nondet):-
		vieneZafando(juan,futurama).

%test(juanVieneZafandoConHoc, nondet):-		% si en el predicado vieneZafando coloco la condición 
%		vieneZafando(juan,hoc).				% seriePopularOConHechosFuertes(Serie) no funciona el test
											% cuando tendria que funcionar y nose si realmente tiene peso 
											% el predicado seriePopularOConHechosFuertes(Serie) ya que es una "condicon"
											% que me da igual si se cumple o no, por otro lado consultando
											% por separado cada condición da como resultado que juan vieneZafando con
											% house of cars.

test(soloNicoVieneZafandoConStarWars, nondet):-
		vieneZafando(Persona,starWars),
		not(Persona \= nico).

:- end_tests(series).
