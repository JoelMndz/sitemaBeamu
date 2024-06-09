export interface IUsuario{
  id: string
  nombres: string
  apellidos: string
  cedula: string
  email: string
  idSucursal?: string
  rol: Rol.ADMINISTRADOR | Rol.SECRETARIO
}

export interface IEmpleado{
  id: string
  nombres: string
  apellidos: string
  rol: Rol.ADMINISTRADOR | Rol.SECRETARIO
  cedula: string
  idSucursal: string | null
  fechaNacimiento: string
  email: string
  fechaRegistro: string
}

export interface IEmpleadoAgregar{
  nombres: string
  apellidos: string
  rol: Rol.ADMINISTRADOR | Rol.SECRETARIO
  cedula: string
  idSucursal: string | null
  fechaNacimiento: string
  email: string
}

export interface ISucursal{
  id: string,
  nombre: string,
  provincia:{
    codigo: string,
    nombre: string
  },
  canton:{
    codigo: string,
    nombre: string
  },
  direccion: string
}

export interface IClienteAgregar{
  nombres: string
  apellidos: string
  cedula: string
  fechaNacimiento: string
  email: string
}

export interface ICliente{
  id: string
  nombres: string
  apellidos: string
  cedula: string
  fechaNacimiento: string
  email: string
  fechaRegistro: string
}

interface IEstado{
  fecha: string
  idEmpleado: string
  estado: Estado
  observacion: string
  imagenURL?: string | null
}

export interface IEnvio{
  id: string
  guia: string
  fechaRegistro: string
  idCliente: string
  pesoKg: number
  entregaDomicilio: boolean
  estados: IEstado[]
  destinatario: {
    nombre: string,
    direccion: string
    celular: string
  }
  idSucursalSalida: string
  idSucursalLlegada: string
  total: number
  sucursalSalida: ISucursal
  sucursalLlegada: ISucursal
  cliente: ICliente
}

export interface IEnvioAgregar{
  idCliente: string
  guia: string
  pesoKg: number
  entregaDomicilio: boolean
  idSecretario: string
  destinatario: {
    nombre: string,
    direccion: string
    celular: string
  }
  observacion: string
  idSucursalSalida: string
  idSucursalLlegada: string
  total: number
}

export interface IEnvioDetalle{
  id: string
  fechaRegistro: string
  idCliente: string
  pesoKg: number
  entregaDomicilio: boolean
  estados: IEstado[]
  destinatario: {
    nombre: string,
    direccion: string
    celular: string
  }
  idSucursalSalida: string
  idSucursalLlegada: string
  total: number
  sucursalSalida: ISucursal,
  sucursalLlegada: ISucursal,
  cliente: ICliente,
}

export enum Rol{
  ADMINISTRADOR = 'administrador',
  SECRETARIO = 'secretario',
  BODEGUERO = 'bodeguero',
  REPARTIDOR = 'repartidor'
}

export enum Estado{
  PENDIENTE = 'pendiente',
  VIAJANDO = 'viajando',
  SUCURSAL = 'sucursal',
  REPARTO = 'reparto',
  ENTREGADO = 'entregado'
}
