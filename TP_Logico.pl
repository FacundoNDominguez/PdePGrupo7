/* <Spoiler Alert> */

%1 Punto A: Quién Mira Qué.

%serie(serie).
serie(himym).
serie(futurama).
serie(got).
serie(madMen).
serie(starWars).
serie(onePiece).
serie(hoc).
serie(drHouse).

%persona(persona).
persona(juan).
persona(nico).
persona(maiu).
persona(gaston).
persona(alf).
persona(aye).

%mira(persona,serie)
mira(juan,himym).
mira(juan,futurama).
mira(juan,got).
mira(nico,starWars).
mira(nico,got).
mira(maiu,onePiece).
mira(maiu,got).
mira(gaston,hoc).

%No se pone en la base de conocimiento que Alf no mira ninguna serie por el principio de universo cerrado.

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

%Ejemplos.
%esSpoiler(serie,paso).
%esSpoiler(starWars,muerte(Emperor)).
%esSpoiler(starWars,relación(parentesco,anakin,rey)).

esSpoiler(Serie,Spoiler):- serie(Serie), paso(Serie,_,_,Spoiler).

%El tipo de consulta que se puede hacer a esta base de conocimientos es existencial ya que puede realizar la consulta por cualquier variable.

%4 Punto C: Te pedí que no me lo dijeras.

%Ejemplos.
%leSpoileo(persona,persona,serie).
%leSpoileo(gastón,maiu,got).
%leSpoileo(nico,maiu,starWars).

leSpoileo(Persona1 , Persona2, Serie):- persona(Persona1), persona(Persona2),
    leDijo(Persona1, Persona2, Serie, _),
    leAfectaElSpoiler(Persona2, Serie),
    Persona1 \= Persona2.

leAfectaElSpoiler(Persona,Serie):- persona(Persona), planeaVer(Persona, Serie).
leAfectaElSpoiler(Persona,Serie):- persona(Persona), mira(Persona, Serie).


%5 Punto D: Responsable.

%Ejemplos.
%televidenteResponsable(persona).
%televienteResponsable(juan).
%televidenteResponsable(aye).
%televidenteResponsable(maiu).

% o podemos poner en efecto: Inversibilidad?
%televidenteResponsable(Responsable).
%Responsable: juan.
%Responsable: aye.
%Responsable: maiu.

televidenteResponsable(Persona1):- %Hay que mejorarlo. No funciona bien.
%Miren como use el not ahi, esta bien Fresh.
  persona(Persona1),
  not(leSpoileo(Persona1,_,_)).

%6 Punto E: Viene Zafando.

%Ejemplos.
%vieneZafando(persona,serie).
%vieneZafando(juan,himym).
%vieneZafando(juan,got).
%vieneZafando

esFuerte(relacion(amorosa,_,_)).
esFuerte(relacion(parentesco,_,_)).
esFuerte(muerte(_)).

vieneSafando(Persona, Serie):-
    persona(Persona),
    not(leSpoileo(_,Persona, Serie)).
