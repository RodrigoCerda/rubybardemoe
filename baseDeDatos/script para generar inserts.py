# -*- coding: utf-8 -*-

import random
rut = ["5559259711","4957046938","3447080839","3734217638","238803885","2443183294","6161755035","8082345024","3751754535","522742493k ","7250115356","8640195097","3307515534","8767419411","563517084k ","9246821765","8142024303","121955235","3970948180","9394583111","2858831744","6313097464","303479799","3898616982","6291192789","1645492340","7672406795","3548178077","6520955528","3417578508","11063511","5974939081","2438967470","708552647","8874804669","5798199060","1046045165","370576009k ","5470212453","994647164","396247294","4124043192","5772189945","3622396754","2864392226","5164832238","542320545k ","8353124051","3097383851","9588227977","8339326736","5931365656","8157164976","300532343","845655505k","9158599100","9841707599","3637602422","5572895181","2501736286","1933201454","8211303968","4618545246","2691382859"]
nombres= ["Juan" , "David" , "Andrea", "Oscar", "Carla", "Vannessa", "Rodrigo", "Matias", "Yasuri", "Maluma", "Fito", "Ramon", "Zoe", "Margarita", "Antonio", "Antonia","Jesus", "Andres", "Tito", "Nelly", "Carlos", "Alberto"]
apellidos =["Abad","Abalos","Abarca","Abendano","Abila","Abina","Abitua","Aboites","Abonce","Abrego","Abrica","Abrigo","Abundis","Aburto","Acebedo","Acebes","Acencio","Acero","Acevedo","Aceves","Acha","Adan","Adrian","Burnett","Bustamante","Bustos","Butanda","Butierres","Byrd","Caacuaa","Caacusi","Caaghu","Caasayu","Caballero","Cabanillas","Cabello","Cabesa","Cabral","Cabrera","Cabriales","Mereles","Merino","Merlin","Merlo","Merodio","Mesquite","Messa","Mexia","Meza","Michaca"]


insert = 1
insertPersona= ""
insertProducto = ""
insertProveedor = ""
insertVenta = ""
insertCompra = ""
insertCuenta = ""

idcuenta = 200
for id in range(1,20):
    montoventa= random.randint(1000,399999)
    insertPersona+= "insert into persona values ("+str(id)+", '"+ random.choice(rut) +"', '"+random.choice(nombres) +"', now(), 777777, 'dasfa@sfda.adsf');\n" 
    insertProducto+= "insert into producto values ( '" + str(random.randint(0,1000)) + "', " +str(random.randint(0,10)) + ", " + str(random.randint(1000,10000)) + ", 'fdsafadsfewrw', "+ str(random.randint(0,100000)) + ");\n"
    insertProveedor+= "insert into proveedor values ( " +str(id) +", '"+random.choice(nombres)+"', now(),"+ str(id) + ", 'asdfadsfdasf');\n"
    insertVenta+= "insert into venta values("+str(id)+", " + str(random.randint(1,20)) + ", " + str(random.randint(1,20)) + ", now(), "+ str(montoventa) + ");\n" 
    insertCompra+= "insert into compra values("+ str(random.randint(1,20)) + ", "+ str(random.randint(1,20)) + ", now(), " + str(random.randint(1000,3000)) + ");\n"
    insertCuenta+= "insert into cuenta values ("+ str(random.randint(10,200)) +", now(), 'activo' );\n"
    #insertCuenta+= "insert into cuenta values ("+str(id)+", "
    idcuenta+= 1
f = open("script.sql","w+")

f.write(insertPersona)
f.write(insertProducto)
f.write(insertProveedor)
f.write(insertVenta)
f.write(insertCompra)
f.write(insertCuenta)