object rolando{
	
	var hechizo 
	var valorBase = 1
	var oscuridad = 5
	var objetos = []
	
	method hechizoNuevo(nuevoHechizo){
		hechizo = nuevoHechizo
	}
	
	method nivelHechiceria() = self.valorBase() * self.hechizoFavorito().poder() + self.valorOscuro()
	
	method valorBase() = valorBase
	
	method hechizoFavorito() = hechizo
	
	method valorOscuro() = oscuridad
	
	method seCreePoderoso() = self.hechizoFavorito().esPoderoso()
	
	method eclipse(){
		oscuridad = oscuridad * 2
	}
	
	method agregarObjeto(objeto){
		self.objetos().add(objeto)
	}
	
	method objetos() = objetos
	
	method habilidadLucha() = self.valorBase() + self.objetos().sum({objeto => objeto.unidadesDeLucha()})
}

object espectroMalefico{
	var nombre = "Espectro Malefico"
	
	method nombre() = nombre
	
	method nombre(nuevoNombre) {
		nombre = nuevoNombre
	}
	
	method poder() = self.nombre().size()
	
	method esPoderoso() = self.poder() > 15
}

object basico{
	method poder() = 10
	
	method esPoderoso() = self.poder() > 15
}


object espadaDelDestino{
	method unidadesDeLucha() = 3
}

object collarDivino{
	var perlas
	
	method perlas() = perlas
	
	method perlas(nuevaCant){
		perlas = nuevaCant
	}
	
	method unidadesDeLucha() = self.perlas()
}

object mascaraOscura{
	var portador
	
	method portador() = portador
	
	method portador(nuevoPortador){
		portador = nuevoPortador
	}
	
	method unidadesDeLucha() = 4.max(self.portador().valorOscuro()/2)
}