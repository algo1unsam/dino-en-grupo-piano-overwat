import wollok.game.*
    
const velocidad = 200

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo + 10
		//COMPLETAR
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"time",{self.pasarTiempo()})
	}
	method detener(){
		//COMPLETAR
	}
}

object cactus {
	 
	var position = self.posicionInicial()

	method image() = "cactus.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{=>self.mover()})
	}
	
	method mover(){
		//COMPLETAR
		if(position.x() <= 0){
			position = self.posicionInicial()
		}else{
			position=position.left(1)
		}
	}
	
	method chocar(){
		//COMPLETAR
		if(self.position() == dino.position()){
			game.schedule(10, { =>self.detener()})
			game.schedule(3000,{ =>game.stop()})
		}
	}
    method detener(){
    	if(dino.vivo()){
	    	game.removeTickEvent("moverCactus")
	    	game.removeTickEvent("time")
			//COMPLETAR
		}
		dino.morir()
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var property vivo = true

	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y()==1){
			position = position.up(1)
			game.schedule(250, {=> position = position.up(1)})
			game.schedule(500, {=> position = position.down(1)})
			game.schedule(750, {=> position = position.down(1)})
				
		}
		//COMPLETAR
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		if(vivo){
			game.schedule(250, {=> position = position.up(1)})
			game.schedule(300, {=> vivo = false})
			game.schedule(500, {=> position = position.down(1)})
			game.schedule(750, {=> position = position.down(1)})
			game.schedule(1000, {=> position = position.down(1)})
			game.schedule(1250, {=> position = position.down(1)})
			game.schedule(1500, {=> position = position.down(1)})
			
		}
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
