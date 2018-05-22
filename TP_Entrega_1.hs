{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions
import Data.List
import Data.Maybe
import Test.Hspec

--TESTS--
testear = hspec $ do
	describe "Test primera entrega" $ do
		it "La billetera deberia quedar en 20, luego de depositar 10"  (  (billetera.deposito 10) pepe `shouldBe` 20 )
		it "La billetera deberia quedar en 7, luego de extraer 3" ( (billetera.extracción 3) pepe `shouldBe` 7)
		it "La billetera deberia quedar en 0, luego de extraer 15" (  (billetera.extracción 15) pepe `shouldBe` 0)
		it "La billetera deberia quedar en 12, luego de un upgrade" ( ( billetera.upgrade) pepe `shouldBe` 12)
		it "La billetera deberia quedar en 0, luego de cerrar cuenta" (  (billetera.cierreDeCuenta) pepe `shouldBe` 0)
		it "La billetera deberia quedar en 10, si no se hace nada" ( ( billetera.quedaIgual) pepe `shouldBe` 10)
		it "La billetera deberia quedar en 1020, luego de depositar 1000 y hacer un upgrade" (  (billetera.upgrade.deposito 1000) pepe`shouldBe` 1020)
		it "La billetera de pepe esta en 10" (billetera pepe `shouldBe` 10)
		it "la Billetera de Pepe queda en 0, luego de un cierre de cuenta" ( (billetera.cierreDeCuenta) pepe `shouldBe` 0)
		it "La billetera deberia quedar en 27.6, luego de depositar 15, extraer 2 y hacer un upgrade" ( ( billetera.upgrade.extracción 2.deposito 15 $ pepe )`shouldBe` 27.6)
		it "La billetera deberia quedar con el monto que se creo al usuario pepe" ( transaccion1 pepe pepe `shouldBe` pepe)
		it "La billetera de Pepe queda en 15, luego de depositar 5 monedas" (transaccion2 pepe pepe `shouldBe` nuevoValorBilletera 15 pepe)
		it "La billetera de Pepe2 queda en 55, luego de depositar 5 monedas y depositar 5 a la nueva billetera que tenia 50 monedas" ( (deposito 5.nuevoValorBilletera 50.deposito 5 ) pepe2 `shouldBe` nuevoValorBilletera 55 pepe2)
		it "La billetera de Lucho queda en 0, luego de depositar 15, hacer un upgrade y cerrar la cuenta" (transaccion3 lucho lucho `shouldBe` nuevoValorBilletera 0 lucho)
		it "La billetera de Lucho2 queda en 34, luego de depositar 1 moneda, luego depositar 2, extraer 1, depositar 8, tener un upgrade, y depositar 10." (transaccion4 lucho2 lucho2 `shouldBe` nuevoValorBilletera 34 lucho2)
		it "La billetera de Pepe queda en 3, luego de extraer 7 monedas" (transaccion5 pepe pepe `shouldBe` nuevoValorBilletera 3 pepe)
		it "La billetera de Lucho2 queda en 17, luego de depositar 7 monedas" (transaccion5 lucho2 lucho2 `shouldBe` nuevoValorBilletera 17 lucho2)


{-
    testN = it "QueTestea" (EstoEjecuta `shouldBe` Resultado)
-}

data Usuario = UnUsuario {
        nombre :: String,
        billetera::Dinero
      } deriving (Show, Eq)

type Dinero = Float

type Transaccion = Usuario -> Usuario

type Evento = Dinero -> Dinero

type ValidacionUsuario = Usuario -> Usuario -> Bool

--EJEMPLOS--
pepe = UnUsuario "Jose" 10
pepe2 = UnUsuario "Jose" 20
lucho = UnUsuario "Luciano" 2
lucho2 = UnUsuario "Luciano" 10

-- 1) EVENTOS

deposito :: Dinero -> Transaccion

deposito dineroADepositar usuario = nuevoValorBilletera (dineroADepositar + billetera usuario ) usuario

extracción :: Dinero -> Transaccion

extracción dineroAExtraer usuario =
        nuevoValorBilletera (resultadoFinal (billetera usuario - dineroAExtraer)) usuario

resultadoFinal :: Evento

resultadoFinal dineroRestado = max dineroRestado 0

upgrade :: Transaccion

upgrade usuario = nuevoValorBilletera (upgradeBilletera.billetera $ usuario ) usuario

upgradeBilletera :: Evento

upgradeBilletera monto = min (monto * 1.2) (monto + 10)


cierreDeCuenta :: Transaccion

cierreDeCuenta unUsuario = nuevoValorBilletera 0 unUsuario

quedaIgual :: Transaccion
quedaIgual = id

tocoYMeVoy :: Transaccion

tocoYMeVoy  = cierreDeCuenta.upgrade.deposito 15

ahorranteErrante :: Transaccion

ahorranteErrante  = deposito 10.upgrade.deposito 8.extracción 1.deposito 2.deposito 1

obtenerTransaccion usuario transaccion usuarioAValidar | validarUsuario usuarioAValidar usuario = transaccion
                                       | otherwise = quedaIgual

transaccion1 :: Usuario -> Transaccion

transaccion1 = obtenerTransaccion lucho cierreDeCuenta

transaccion2 :: Usuario -> Transaccion

transaccion2 = obtenerTransaccion pepe (deposito 5)

transaccion3 :: Usuario -> Transaccion

transaccion3 = obtenerTransaccion lucho tocoYMeVoy

transaccion4 :: Usuario -> Transaccion

transaccion4 = obtenerTransaccion lucho ahorranteErrante

transaccion5 :: Usuario -> Transaccion

transaccion5 usuarioAValidar| nombre usuarioAValidar == "Jose" = obtenerTransaccion pepe (extracción 7) usuarioAValidar
                            | nombre usuarioAValidar == "Luciano" = obtenerTransaccion lucho (deposito 7) usuarioAValidar

validarUsuario :: ValidacionUsuario

validarUsuario usuarioAValidar usuario = (nombre usuario) == (nombre usuarioAValidar)

--Funcion para hacer tests

nuevoValorBilletera nuevoValor unUsuario= unUsuario {billetera = nuevoValor}



{-

 ___________  ______          _         _____
|_   _| ___ \ | ___ \        | |       / __  \ _
  | | | |_/ / | |_/ /_ _ _ __| |_ ___  `' / /'(_)
  | | |  __/  |  __/ _` | '__| __/ _ \   / /
  | | | |     | | | (_| | |  | ||  __/ ./ /___ _
  \_/ \_|     \_|  \__,_|_|   \__\___| \_____/(_)


 _             _   _                                           ___
| |           | | | |                                         /   |
| |     __ _  | | | | ___ _ __   __ _  __ _ _ __  ______ _   / /| |
| |    / _` | | | | |/ _ \ '_ \ / _` |/ _` | '_ \|_  / _` | / /_| |
| |___| (_| | \ \_/ /  __/ | | | (_| | (_| | | | |/ / (_| | \___  |
\_____/\__,_|  \___/ \___|_| |_|\__, |\__,_|_| |_/___\__,_|     |_/
                                 __/ |
                                |___/


-}
{-
testear2 = hspec $ do
    test18
    test19
    test20
    test21
    test22
    test23
    test24
    --test25
    test26
    test27
    test28

test18 = it "Impactar la transacción 1 a Pepe. Debería quedar igual que como está inicialmente" (transaccion1 pepe pepe `shouldBe` pepe)

test19 = it "Impactar la transacción 5 a Lucho. Debería producir que Lucho tenga 9 monedas en su billetera" (transaccion5 lucho lucho `shouldBe` (nuevoValorBilletera 9 lucho))

test20 = it "Impactar la transacción 5 y luego la 2 a Pepe. Eso hace que tenga 8 en su billetera" ( (transaccion2 pepe.transaccion5 pepe)  pepe `shouldBe` (nuevoValorBilletera 8  pepe))

test21 = it "Aplicar bloque1 a pepe. Esto hace que tenga 18 en su billetera" (formarBloque bloque1 pepe `shouldBe` (nuevoValorBilletera 18 pepe))

test22 = it "Aplicar bloque1 al conjuntos de usuarios [pepe,lucho] y determinar quien queda con mas de 10 creditos. Esto hace que quede pepe" ( saldoMayorA 10 ( aplicarBloqueAUsuarios bloque1 [pepe,lucho] ) `shouldBe` [nuevoValorBilletera 18 pepe] )

test23 = it "Al aplicar el bloque 1 a pepe y lucho, pepe es el mas adinerado" ( usuarioMasAdinerado (aplicarBloqueAUsuarios bloque1 [pepe, lucho] ) `shouldBe` (nuevoValorBilletera 18 pepe) )

test24 = it "Al aplicar el bloqie 1 a pepe y a lucho, lucho es el menos adinerado" ( usuarioMenosAdinerado (aplicarBloqueAUsuarios bloque1 [pepe, lucho] ) `shouldBe` (nuevoValorBilletera 0 lucho) )

--test25 = it "de los bloques del blockchain el peor para pepe es el bloque 1" ( peorBloque pepe  `shouldBe` bloque1 )

test26 = it "al aplicar el block chain a pepe, este queda con 115 monedas" ( formarBlockChain pepe  `shouldBe` (nuevoValorBilletera 115 pepe) )

test27 = it "despues de la tercera iteracion del blockchain, pepe queda con 51 monedas" ( usuarioDespuesDeNBloques pepe blockChain 3 `shouldBe` (nuevoValorBilletera 51 pepe) )

test28 = it "Despues de aplicar el block chain a lucho y a pepe, lucho queda con 0 monedas y pepe con 115" ( usuariosDespuesDelBlockChain [pepe,lucho] `shouldBe` [nuevoValorBilletera 115 pepe, nuevoValorBilletera 0 lucho])

type Bloque = [Transaccion]

bloque1 :: Bloque

bloque1 = [transaccion3,transaccion5,transaccion4,transaccion3,transaccion2,transaccion2,transaccion2,transaccion1]

formarBloque :: Bloque -> Transaccion
formarBloque bloque usuario = foldl1 (.) bloque

aplicarBloqueAUsuarios :: Bloque -> [Usuario] -> [Usuario]
aplicarBloqueAUsuarios bloque usuarios = map (formarBloque bloque) usuarios

saldoMayorA :: Float -> [Usuario] -> [Usuario]
saldoMayorA numero usuarios = filter ((>numero).billetera) usuarios

billeteraMasCargada :: [Usuario] -> Float
billeteraMasCargada usuarios = maximum (map billetera usuarios)

usuarioMasAdinerado :: [Usuario] -> Usuario
usuarioMasAdinerado usuarios = head $ filter ( (==billeteraMasCargada usuarios).billetera ) usuarios

billeteraMenosCargada :: [Usuario] -> Float
billeteraMenosCargada usuarios = minimum (map billetera usuarios)

usuarioMenosAdinerado :: [Usuario] -> Usuario
usuarioMenosAdinerado usuarios = head $ filter ( (==billeteraMenosCargada usuarios).billetera ) usuarios

type BlockChain = [Bloque]

bloque2 :: Bloque
bloque2 = [transaccion2,transaccion2,transaccion2,transaccion2,transaccion2]

formarBlockChain :: Transaccion
formarBlockChain = formarBloque (concat blockChain)

blockChain :: BlockChain
blockChain = [bloque2,bloque1,bloque1,bloque1,bloque1,bloque1,bloque1,bloque1,bloque1,bloque1,bloque1]

aplicarTransaccionAUsuario :: Usuario -> Transaccion -> Usuario
aplicarTransaccionAUsuario usuario transaccion = transaccion usuario

evaluaraUsuarioPorBloque :: Usuario -> [Usuario]
evaluaraUsuarioPorBloque usuario = map ( aplicarTransaccionAUsuario usuario ) (map (formarBloque) blockChain)

verificarPeorBloque :: Usuario -> Bloque -> Bool
verificarPeorBloque usuario bloque = (usuarioMenosAdinerado (evaluaraUsuarioPorBloque usuario) ) == (aplicarTransaccionAUsuario usuario (formarBloque bloque) )

peorBloque :: Usuario -> Bloque
peorBloque usuario = fromJust (find (verificarPeorBloque usuario) blockChain)

usuarioDespuesDeNBloques usuario (x:xs) n | n==0 = usuario
                                          | (length xs == 0 ) = (formarBloque x) usuario
                                          | otherwise = usuarioDespuesDeNBloques ( (formarBloque x) usuario) xs (n-1)

usuariosDespuesDelBlockChain :: [Usuario] -> [Usuario]
usuariosDespuesDelBlockChain usuarios = map (formarBlockChain) usuarios

blockChainInfinito :: Bloque -> BlockChain
blockChainInfinito bloque = repeat (bloque ++ bloque)

listaDeIndices = iterate (+1) 1

verificarSiElUsuarioTieneMasDeNMonedasDespuesDeNBloques usuario monedas block n = billetera (usuarioDespuesDeNBloques usuario block n) > monedas

bloquesNecesarioParaObtenerNMonedas usuario monedas block = find (verificarSiElUsuarioTieneMasDeNMonedasDespuesDeNBloques usuario monedas block) listaDeIndices

-}