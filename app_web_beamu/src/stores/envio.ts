import { type IEnvio, type ITipoEnvio, type IEnvioAgregar, Estado, type ISucursal, type ICliente, type IEnvioDetalle } from "@/types"
import { addDoc, collection, doc, getDocs, getFirestore, query, updateDoc, where } from "firebase/firestore"
import { defineStore } from "pinia"
import { jsPDF } from "jspdf";
import { useClienteStore } from "./cliente";
import { useSucursalStore } from "./sucursal";
import qrcode from "qrcode";
import { useAutenticacionStore } from "./autenticacion";

interface IState{
  modal: boolean
  cargando: boolean
  envioPorEliminar: IEnvio | null
  tiposEnvios: ITipoEnvio[]
  envios: IEnvio[]
  envioPorEntregar: IEnvio | null
}

const _nombreColleccion = "envios"

export const useEnvioStore = defineStore('envios', {
  state: ():IState => ({
    modal: false,
    cargando: false,
    envioPorEliminar: null,
    envios: [],
    tiposEnvios: [],
    envioPorEntregar: null
  }),
  actions: {
    abrirModal(){
      this.modal = true;
    },
    ocultarModal(){
      this.modal = false
      this.envioPorEliminar = null
    },
    async obtenerTiposEnvios(){
      try {
        this.cargando = true;
        const {docs} = await getDocs(
          query(
            collection(getFirestore(), "tipo_envio"),
          )
        );
        this.tiposEnvios = docs.map(x => {
          const documento = x.data()
          return {
            id: x.id, 
            nombre: documento['nombre'],
            descripcion: documento['descripcion'],
            pesoMaximoKg: documento['pesoMaximoKg'],
            precioKg: documento['precioKg'],
          }
        })
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
      }
    },
    async obtenerTodo(){
      const {clientes} = useClienteStore()
      const {sucursales} = useSucursalStore()
      try {
        this.cargando = true;
        const {docs} = await getDocs(
          query(
            collection(getFirestore(), _nombreColleccion),
            where('eliminado','==',false)
          )
        );
        this.envios = docs.map(x => {
          const documento = x.data()
          return {
            id: x.id, 
            fechaRegistro: documento['fechaRegistro'],
            idCliente: documento['idCliente'],
            idTipoEnvio: documento['idTipoEnvio'],
            pesoKg: documento['pesoKg'],
            entregaDomicilio: documento['entregaDomicilio'],
            estados: documento['estados'],
            destinatario: documento['destinatario'],
            total: documento['total'],
            idSucursalSalida: documento['idSucursalSalida'],
            idSucursalLlegada: documento['idSucursalLlegada'],
            cliente: clientes.find(x => x.id == documento['idCliente'])!,
            sucursalSalida: sucursales.find(x => x.id == documento['idSucursalSalida'])!,
            sucursalLlegada: sucursales.find(x => x.id == documento['idSucursalLlegada'])!,
            tipoEnvio: this.tiposEnvios.find(x => x.id == documento['idTipoEnvio'])!
          }
        })
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
      }
    },
    async agregar(envio: IEnvioAgregar){
      try {
        const {clientes} = useClienteStore()
        const {sucursales} = useSucursalStore()
        this.cargando = true;
        const fechaRegistro = new Date().toUTCString()
        const datosEnvio = {
          fechaRegistro,
          idCliente: envio.idCliente,
          idTipoEnvio: envio.idTipoEnvio,
          pesoKg: envio.pesoKg,
          entregaDomicilio: envio.entregaDomicilio,
          estados: [{
            fecha: fechaRegistro,
            idEmpleado: envio.idSecretario,
            estado: Estado.PENDIENTE,
            observacion: envio.observacion
          }],
          destinatario: envio.destinatario,
          total: envio.total,
          idSucursalSalida: envio.idSucursalSalida,
          idSucursalLlegada: envio.idSucursalLlegada,
          eliminado: false
        }
        const envioAgregado = await addDoc(collection(getFirestore(), _nombreColleccion), datosEnvio)
        const envioTemporal = {
          ...datosEnvio,
          id: envioAgregado.id,
          cliente: clientes.find(x => x.id == datosEnvio['idCliente'])!,
            sucursalSalida: sucursales.find(x => x.id == datosEnvio['idSucursalSalida'])!,
            sucursalLlegada: sucursales.find(x => x.id == datosEnvio['idSucursalLlegada'])!,
            tipoEnvio: this.tiposEnvios.find(x => x.id == datosEnvio['idTipoEnvio'])!
        }
        this.envios.push(envioTemporal)
        this.generarPDF(envioTemporal)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.ocultarModal()
      }
    },
    async eliminar(){
      try {
        this.cargando = true;
        await updateDoc(doc(getFirestore(),_nombreColleccion, this.envioPorEliminar!.id),{
         eliminado: true
        })
        this.envios = this.envios.filter(x => x.id !== this.envioPorEliminar!.id)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.envioPorEliminar = null;
      }
    },
    abrirConfirmacionEliminar(envio: IEnvio){
      this.envioPorEliminar = {...envio}
    },
    cancelarConfirmacionEliminar(){
      this.envioPorEliminar = null
    },
    async entregarEnvio(observacion:string){
      try {
        this.cargando = true;
        const {usuario} = useAutenticacionStore();
        this.envioPorEntregar!.estados.push({
          estado: Estado.ENTREGADO,
          fecha: new Date().toUTCString(),
          idEmpleado: usuario!.id,
          observacion
        })
        await updateDoc(doc(getFirestore(), _nombreColleccion, this.envioPorEliminar!.id),{
         estados: this.envioPorEntregar!.estados
        });
        this.envios = this.envios.map(x => x.id !== this.envioPorEntregar!.id ? x : this.envioPorEntregar!)
      } catch (error) {
        console.log(error);
      }finally{
        this.cargando = false;
        this.envioPorEntregar = null;
      }
    },
    abrirModalParaEntregar(envio:IEnvio){
      this.envioPorEntregar = {...envio};      
    },
    cerrarModalParaEntregar(){
      this.envioPorEntregar = null;
    },
    async generarPDF(envio:IEnvio){
      const {clientes} = useClienteStore()
      const {sucursales} = useSucursalStore()
      const cliente = clientes.find(x => x.id === envio.idCliente)
      const sucursalSalida = sucursales.find(x => x.id === envio.idSucursalSalida)
      const sucursalLlegada = sucursales.find(x => x.id === envio.idSucursalLlegada)
      
      //Crear pdf
      const pdf = new jsPDF()
      pdf.setFontSize(18)
      pdf.text('Factura BEMAU',105,15,{align:"center"})
      
      pdf.setFontSize(12)
      pdf.text(`Fecha: ${new Date(envio.fechaRegistro).toLocaleString()}`, 20, 30);
      pdf.text(`Código: ${envio.id}`, 20, 40);
      pdf.text(`Cliente: ${cliente?.nombres} ${cliente?.apellidos}`, 20, 50);
      pdf.text(`Nombre destinatario: ${envio.destinatario.nombre}`, 20, 70);
      pdf.text(`Celular destinatario: ${envio.destinatario.celular}`, 20, 80);
      pdf.text(`Dirección destinatario: ${envio.destinatario.direccion}`, 20, 90);
      pdf.text(`Sucursal Salida: ${sucursalSalida?.nombre}`, 20, 100);
      pdf.text(`Sucursal Llegada: ${sucursalLlegada?.nombre}`, 20, 110);
      pdf.text(`Peso: ${envio.pesoKg} Kg`, 20, 120);
      pdf.text(`Total: $ ${envio.total} `, 20, 130);

      pdf.addPage()
      pdf.text('Identificador QR, pegar en el paquete',15,10)
      pdf.addImage(await qrcode.toDataURL(envio.id),20,20,100,100)

      //Descargar pdf
      const pdfURL = pdf.output('dataurlstring')
      const enlaceTemporal = document.createElement('a');
      enlaceTemporal.href = pdfURL
      enlaceTemporal.download = `Factura-${new Date(envio.fechaRegistro).toLocaleDateString()}.pdf`;
      enlaceTemporal.click();
    }
  }
})