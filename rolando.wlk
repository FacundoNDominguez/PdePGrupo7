object rolando{
	
	var property hechizo 
	var property valorBase = 1
	var oscuridad = 5
	var property objetos = []
	
	method hechizoNuevo(nuevoHechizo){
		hechizo = nuevoHechizo
	}
	
	method nivelHechiceria() = self.valorBase() * self.hechizo().poder() + self.valorOscuro()
	
	method valorOscuro() = oscuridad
	
	method seCreePoderoso() = self.hechizo().esPoderoso()
	
	method eclipse(){
		oscuridad = oscuridad * 2
	}
	
	method agregarObjeto(objeto){
		self.objetos().add(objeto)
	}
	
	method quitarAtefactos() = self.objetos().clear()
	
	method habilidadLucha() = self.valorBase() + self.objetos().sum({objeto => objeto.unidadesDeLucha()})

	method masGuerreroQueHechizero() = self.habilidadLucha() > self.nivelHechiceria()
}

class Hechizo{
	method poder()
	
	method esPoderoso() = self.poder() > 15
}

object espectroMalefico inherits Hechizo{
	var nombre = "Espectro Malefico"
	
	method nombre() = nombre
	
	method nombre(nuevoNombre) {
		nombre = nuevoNombre
	}
	
	override method poder() = self.nombre().size()
	
}

object basico inherits Hechizo{
	override method poder() = 10
	
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
	var property portador

	method unidadesDeLucha() = 4.max(self.portador().valorOscuro()/2)
}





object armadura{
	var property refuerzo
	
	method unidadesDeLucha() = 2 + self.refuerzo().unidadesDeRefuerzo()
}

object cotaDeMalla{
	method unidadesDeRefuerzo() = 1
}

object bendicion{
	var property portador
	
	method unidadesDeRefuerzo() = self.portador().nivelHechiceria()
}

object hechizoDeEncanto{
	var property hechizo
	
	method unidadesDeRefuerzo() = self.hechizo().poder()
}


object espejo{
	var property portador
	
	method unidadesDeLucha() = self.portador().objetos().max({objeto=> objeto.unidadesDeLucha()})
}

object libroDeHechizos{
	var property hechizos
	
	method agregarHechizo(unHechizo){
		self.hechizos().add(unHechizo)
	}
	
	method unidadesDeLucha() = self.hechizos().filter({hechizo => hechizo.esPoderoso()}).sum({hechizo => hechizo.poder()})
}