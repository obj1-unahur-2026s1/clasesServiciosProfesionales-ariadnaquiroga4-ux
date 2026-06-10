class universidad {
   const property provincia 
   const property honorarios  
   var totalDonaciones = 0
   method recibirDonacion(importe) {
     totalDonaciones += importe
   }
}
class profesional {
  method cobrar(importe) {}
}
class profesionalVinculado inherits profesional {
    const property universidad
    method honorarios() = universidad.honorarios()
    method provincia() = [universidad.provincia()]
    override method cobrar(importe) {
        universidad.recibirDonacion(importe/2)
    }
}
object asociacionLitoral {
  var totalRecaudado = 0
  method cobrar(importe) {
    totalRecaudado += importe
  }
}
class profesionalLitoral {
    const property universidad
    method honorarios() = 3000
    method provincia() = ["Entre Rios","Santa Fe","Corrientes"]
    method cobrar(importe) {
      asociacionLitoral.cobrar(importe)
    }
}
class profesionalLibres inherits profesional {
    const property universidad
    const property honorarios
    const property provincia
    var totalRecaudado = 0
    method honorarios() = honorarios
    method provinciasHabilitadas() = provincia
    override method cobrar(importe) {
        totalRecaudado += importe
    }
    method pasarDinero(unProfesional , importe) {
      totalRecaudado -= importe
      unProfesional.cobrar(importe)
    }
}

class empresa {
    const property profesionales
    const property honorarioReferencia
    const property clientes = []
    method cuantosProfesionalesEstudiaronEn(uni) {
        return profesionales.filter(p => p.universidad == uni).size()
    }
    method profesionalesCaros() {
        return profesionales.filter(p => p.honorarios() > honorarioReferencia)
    }
    method universidadesDeProfesionales() {
        return profesionales.map(p => p.universidad).asSet()
    }
    method profesionalMasBarato() {
        return profesionales.min(p => p.honorarios())
    }
    method esGenteAcotada() {
      return profesionales.all(p => p.provincia().size() <= 3)
    }
    method puedeSatisfacer(solicitante) {
      profesionales.any({p => solicitante.puedeSerAtendidoPor(p)})
    }
    method darServicio(solicitante) {
        if(self.puedeSatisfacer(solicitante)) {
            const profesional = profesionales.find({p => solicitante.puedeSerAtendidoPor(p)})
        }
        profesional.cobrar(profesional.honorarios())
        clientes.add(solicitante)
    }
    method cantidadClientes() {
      clientes.size()
    }
    method tieneComoCliente(solicitante) = clientes.contains(solicitante) 
    method esPocoAtractivo(profesional) {
      profesional.provincias().all({provincias => profesional.any({otro => otro != profesional && otro.honorarios() < profesional.honorarios() && otro.provincia().contains(provincia)})})
    }
}

class solicitantes {
  method puedeSerAtendidosPor(profesional)
}
class persona inherits solicitantes {
  const property provincia 
  override method puedeSerAtendidoPor(profesional) = profesional.provincia().contains(provincia) 
}
class intitucion inherits solicitantes {
  const property universidadesReconocidas  
  override method puedeSerAtendidoPor(profesional) = universidadesReconocidas.contains(profesional.universidad()) 
}
class club inherits solicitantes {
  const property provincias
  override method puedeSerAtendidoPor(profesional) = provincias.any({p => p.provincia().contains(provincias)}) 
}

