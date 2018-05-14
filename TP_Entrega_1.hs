{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions
import Data.List
import Data.Maybe
import Test.Hspec

--TESTS--
testear = hspec $ do
    test1
    test2
    test3
    test4
    test5
    test6
    test7
    test8
    test9
    test10
    test11
    test12
    test13
    test14
    test15
    test16
    test17

test1 = it "La billetera deberia quedar en 20, luego de depositar 10"  (  (billetera.deposito 10) pepe `shouldBe` 20 )

test2 = it "La billetera deberia quedar en 7, luego de extraer 3" ( (billetera.extracción 3) pepe `shouldBe` 7)

test3 = it "La billetera deberia quedar en 0, luego de extraer 15" (  (billetera.extracción 15) pepe `shouldBe` 0)

test4 = it "La billetera deberia quedar en 12, luego de un upgrade" ( ( billetera.upgrade) pepe `shouldBe` 12)

test5 = it "La billetera deberia quedar en 0, luego de cerrar cuenta" (  (billetera.cierreDeCuenta) pepe `shouldBe` 0)

test6 = it "La billetera deberia quedar en 10, si no se hace nada" ( ( billetera.quedaIgual) pepe `shouldBe` 10)

test7 = it "La billetera deberia quedar en 1020, luego de depositar 1000 y hacer un upgrade" (  (billetera.upgrade.deposito 1000) pepe`shouldBe` 1020)

test8 = it "La billetera de pepe esta en 10" (billetera pepe `shouldBe` 10)

test9 = it "la Billetera de Pepe queda en 0, luego de un cierre de cuenta" ( (billetera.cierreDeCuenta) pepe `shouldBe` 0)

test10 = it "La billetera deberia quedar en 27.6, luego de depositar 15, extraer 2 y hacer un upgrade" ( ( billetera.upgrade.extracción 2.deposito 15 $ pepe )`shouldBe` 27.6)

test11 = it "La billetera deberia quedar con el monto que se creo al usuario pepe" ( transaccion1 pepe `shouldBe` pepe)

test12 = it "La billetera de Pepe queda en 15, luego de depositar 5 monedas" (transaccion2  pepe `shouldBe` nuevoValorBilletera 15 pepe)

test13 = it "La billetera de Pepe2 queda en 55, luego de depositar 5 monedas y depositar 5 a la nueva billetera que tenia 50 monedas" ( (deposito 5.nuevoValorBilletera 50.deposito 5 ) pepe2 `shouldBe` nuevoValorBilletera 55 pepe2)

test14 = it "La billetera de Lucho queda en 0, luego de depositar 15, hacer un upgrade y cerrar la cuenta" (transaccion3 lucho `shouldBe` nuevoValorBilletera 0 lucho)

test15 = it "La billetera de Lucho2 queda en 34, luego de depositar 1 moneda, luego depositar 2, extraer 1, depositar 8, tener un upgrade, y depositar 10." (transaccion4 lucho2 `shouldBe` nuevoValorBilletera 34 lucho2)

test16 = it "La billetera de Pepe queda en 3, luego de extraer 7 monedas" (transaccion5 pepe `shouldBe` nuevoValorBilletera 3 pepe)

test17 = it "La billetera de Lucho2 queda en 17, luego de depositar 7 monedas" (transaccion5 lucho2 `shouldBe` nuevoValorBilletera 17 lucho2)

{-
    testN = it "QueTestea" (EstoEjecuta `shouldBe` Resultado)
-}

data Usuario = UnUsuario {
        nombre :: String,
        billetera::Dinero
      } deriving (Show, Eq)

type Dinero = Float

type Transaccion = Usuario -> Usuario

type ValidacionUsuario = String -> Usuario -> Bool

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

resultadoFinal :: Dinero -> Dinero

resultadoFinal dineroRestado | dineroRestado  > 0 = dineroRestado
                             | otherwise          = 0

upgrade :: Transaccion

upgrade usuario = nuevoValorBilletera (upgradeBilletera.billetera $ usuario ) usuario

upgradeBilletera :: Dinero -> Dinero

upgradeBilletera monto | monto * 0.2 < 10 = monto * 1.2
                       | otherwise        = monto + 10


cierreDeCuenta :: Transaccion

cierreDeCuenta unUsuario = nuevoValorBilletera 0 unUsuario

quedaIgual :: Transaccion
quedaIgual = id

tocoYMeVoy :: Transaccion

tocoYMeVoy  = cierreDeCuenta.upgrade.deposito 15

ahorranteErrante :: Transaccion

ahorranteErrante  = deposito 10.upgrade.deposito 8.extracción 1.deposito 2.deposito 1

{-

transaccion :: Int -> Transaccion

transaccion numeroDeTransaccion usuario = (obtenerOperacion numeroDeTransaccion usuario) usuario

obtenerOperacion :: Int -> Usuario -> Transaccion

obtenerOperacion n usuario     | n == 1 && validarUsuario "Luciano" usuario = cierreDeCuenta
                            | n == 2 && validarUsuario "Jose" usuario = deposito 5
                            | n == 3 && validarUsuario "Luciano" usuario = tocoYMeVoy
                            | n == 4 && validarUsuario "Luciano" usuario = ahorranteErrante
                            | n == 5 && validarUsuario "Jose" usuario = extracción 7
                            | n == 5 && validarUsuario "Luciano" usuario = deposito 7
                             | otherwise = quedaIgual
-}

aplicarTransaccion usuario nombreUsuario transaccion | validarUsuario nombreUsuario usuario = transaccion usuario
                                                     | otherwise = quedaIgual usuario

transaccion1 usuario = aplicarTransaccion usuario "Luciano" cierreDeCuenta

transaccion2 usuario = aplicarTransaccion usuario "Jose" (deposito 5)

transaccion3 usuario = aplicarTransaccion usuario "Luciano" tocoYMeVoy

transaccion4 usuario = aplicarTransaccion usuario "Luciano" ahorranteErrante

transaccion5 usuario | nombre usuario == "Jose" = aplicarTransaccion usuario "Jose" (extracción 7)
                     | nombre usuario == "Luciano" = aplicarTransaccion usuario "Luciano" (deposito 7)

validarUsuario :: ValidacionUsuario

validarUsuario nombreUsuario usuario = (nombre usuario) == nombreUsuario

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

type Bloque = [Transaccion]

bloque1 :: Bloque

bloque1 = [transaccion3,transaccion5,transaccion4,transaccion3,transaccion2,transaccion2,transaccion2,transaccion1]

formarBloque :: Bloque -> Transaccion
formarBloque bloque = foldl1 (.) bloque

testear2 = hspec $ do
    test18
    test19
    test20
    test21
    test22
    test23

test18 = it "Impactar la transacción 1 a Pepe. Debería quedar igual que como está inicialmente" (transaccion1 pepe `shouldBe` pepe)

test19 = it "Impactar la transacción 5 a Lucho. Debería producir que Lucho tenga 9 monedas en su billetera" (transaccion5 lucho `shouldBe` (nuevoValorBilletera 9 lucho))

test20 = it "Impactar la transacción 5 y luego la 2 a Pepe. Eso hace que tenga 8 en su billetera" ( (transaccion2.transaccion5)  pepe `shouldBe` (nuevoValorBilletera 8  pepe))

test21 = it "Aplicar bloque1 a pepe. Esto hace que tenga 18 en su billetera" (formarBloque bloque1 pepe `shouldBe` (nuevoValorBilletera 18 pepe))

test22 = it "Aplicar bloque1 al conjuntos de usuarios [pepe,lucho] y determinar quien queda con mas de 10 creditos. Esto hace que quede pepe" ( saldoMayorA 10 ( aplicarBloqueAUsuarios bloque1 [pepe,lucho] ) `shouldBe` [nuevoValorBilletera 18 pepe] )

test23 = it "Al aplicar el bloque 1 a pepe y lucho, lucho es el mas adinerado" ( usuarioMasAdinerado (aplicarBloqueAUsuarios bloque1 [pepe, lucho] ) `shouldBe` (nuevoValorBilletera 18 pepe) )

aplicarBloqueAUsuarios :: Bloque -> [Usuario] -> [Usuario]
aplicarBloqueAUsuarios bloque usuarios = map (formarBloque bloque) usuarios

saldoMayorA :: Float -> [Usuario] -> [Usuario]
saldoMayorA numero usuarios = filter ((>numero).billetera) usuarios

billeteraMasCargada :: [Usuario] -> Float
billeteraMasCargada usuarios = maximum (map billetera usuarios)

usuarioMasAdinerado :: [Usuario] -> Usuario
usuarioMasAdinerado usuarios = head $ filter ( (==billeteraMasCargada usuarios).billetera ) usuarios

