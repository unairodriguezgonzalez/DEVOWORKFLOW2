/** 
* Class AccountControllerExtension
**
* @Funcionalidad: Extensión de controlador para la generación del informe de matriculas en la página visualforce MatriculasSI.page
**
* @Autor: arodriguez (20/11/2012)
**
* @Modificaciones:  
**/
public with sharing class AccountControllerExtension {

	private final Account colegio;
	public List<GroupedQuery> solisBilbao {get;set;}
	public List<GroupedQuery> solisDonosti {get;set;}
	public List<GroupedQuery> solisVitoria {get;set;}
	public List<GroupedQuery> solisBicampus {get;set;}
	public Map<String,GroupedQuery> solis1 {get;set;}
	public Map<String,GroupedQuery> solis2 {get;set;}
	public Map<String,GroupedQuery> solis3 {get;set;}
	public Map<String,GroupedQuery> solis4 {get;set;}
	public String curso1 {get;set;}
	public String curso2 {get;set;}
	public String curso3 {get;set;}
	public totales total {get;set;}
	
	//Variables para mostrar el total de matriculas.
	public class totales
	{
	  public Integer totalCurso1Bilbao {get;set;}
	  public Integer totalCurso2Bilbao {get;set;}
	  public Integer totalCurso3Bilbao {get;set;}
	  public Integer totalCurso1Donosti {get;set;}
	  public Integer totalCurso2Donosti {get;set;}
	  public Integer totalCurso3Donosti {get;set;}
	  public Integer totalCurso1Vitoria {get;set;}
	  public Integer totalCurso2Vitoria {get;set;}
	  public Integer totalCurso3Vitoria {get;set;}
	  public Integer totalCurso1Bicampus {get;set;}
	  public Integer totalCurso2Bicampus {get;set;}
	  public Integer totalCurso3Bicampus {get;set;}  
	  public Integer totalUD1 {get;set;}
	  public Integer totalUD2 {get;set;}
	  public Integer totalUD3 {get;set;}    
	}
	
	//Objeto para mostrar en la tabla.
	public class GroupedQuery
	{
	  public Integer anio1 {get;set;}
	  public Integer anio2 {get;set;}
	  public Integer anio3 {get;set;}
	  public String codigo {get;set;}
	  public string Titulacion {get;set;}
	  public decimal orden {get;set;}
	}
	
	public AccountControllerExtension(ApexPages.StandardController stdController)
	{
	  //Inicializamos las variables
	  total = new totales();
	  total.totalCurso1Donosti=0;
	  total.totalCurso2Donosti=0;
	  total.totalCurso3Donosti=0;
	  total.totalUD1=0;
	  total.totalUD2=0;
	  total.totalUD3=0;
	  total.totalCurso1Bilbao=0;
	  total.totalCurso2Bilbao=0;
	  total.totalCurso3Bilbao=0;
	  total.totalCurso1Vitoria=0;
	  total.totalCurso2Vitoria=0;
	  total.totalCurso3Vitoria=0;
	  total.totalCurso1Bicampus=0;
	  total.totalCurso2Bicampus=0;
	  total.totalCurso3Bicampus=0;
	  this.colegio = (Account)stdController.getRecord();
	  
	  if (this.colegio != null)
	  {      
	  
	  //Calculamos el año academico actual y los anteriores dos. (Se nos pide hacer el informe de las matriculas del año actual y los 2 anteriores.)
	  Datetime fechaActual = datetime.now();  
	  string cursoActual = '';
	  Integer anyo = 0;
	  String aux = '';
		  
	  if(fechaActual != null)
	  {
		if(fechaActual.month() > 8)
		{
		anyo = fechaActual.year() + 1;
		aux = String.valueOf(anyo);
		curso1 = String.valueOf(fechaActual.year()) + '-' + aux.substring(2);
		aux = String.valueOf(anyo-1);
		curso2 = String.valueOf(fechaActual.year()-1) + '-' + aux.substring(2);
		aux = String.valueOf(anyo-2);
		curso3 = String.valueOf(fechaActual.year()-2) + '-' + aux.substring(2);
		}
		else
		{
		anyo = fechaActual.year();
		aux = String.valueOf(anyo);
		curso1 = String.valueOf(fechaActual.year() - 1) + '-' + aux.substring(2);
		aux = String.valueOf(anyo-1);
		curso2 = String.valueOf(fechaActual.year() - 2) + '-' + aux.substring(2);
		aux = String.valueOf(anyo-2);
		curso3 = String.valueOf(fechaActual.year() - 3) + '-' + aux.substring(2);
		}
	  }        
	  
	  //Lanzamos la query para recuperar las matriculas
	  List<Solicitud_de_admision_de_grado__c> queries = [SELECT Curso_academico__c, Matriculado_en__r.Orden_etiquetas__c, Campus__c,Matriculado_en__r.Name,Matriculado_en__r.Codigo__c, Matriculado_en__r.Campus__c FROM Solicitud_de_admision_de_grado__c where Candidato__r.Centro_de_ensenanza__c = : this.colegio.Id AND Matriculado_en__c!=NULL AND Matriculado_en__c!='' order by Opcion1__r.Orden_etiquetas__c];
	  
	  //Creamos 2 mapas, uno para las matriculas de Bilbao y otro para las de Donosti.
	  solis1 = new Map<String,GroupedQuery>();
	  solis2 = new Map<String,GroupedQuery>();
	  solis3 = new Map<String,GroupedQuery>();
	  solis4 = new Map<String,GroupedQuery>();
	  
	  
	  for (Solicitud_de_admision_de_grado__c query: queries)
	  {          
		System.debug('CONSOLE:'+query); //DEBUG
		System.debug('CONSOLE:'+query.Matriculado_en__r.Orden_etiquetas__c); //DEBUG
		
		//Recogemos el nombre de la titulación, el código y el curso academico de cada SAD.
		GroupedQuery myObject = new GroupedQuery();
		myObject.Titulacion = query.Matriculado_en__r.Name;
		myObject.codigo = query.Matriculado_en__r.Codigo__c;
		myObject.orden = query.Matriculado_en__r.Orden_etiquetas__c;
		String anioAux = query.Curso_academico__c;
			  
		//Si la SAD es para el campus de Bilbao, sumamos 1 al año que corresponda.
		//Una vez encontrado el año y el campus de la SAD lo incluimos en el mapa con la titulación como "key". 
		//De esta forma cuando encontremos una SAD de la misma titulación, solo recogemos del map y sumamos 1 al número de matriculas del año que corresponda.
		System.debug('matriculado en campus: '+query.Matriculado_en__r.Campus__c);
		if (query.Matriculado_en__r.Campus__c=='0')
		{            
		  if (solis1.get(myObject.Titulacion)!=null)//Comprobamos el map
		  {
		  GroupedQuery numeroTitulados = solis1.get(myObject.Titulacion);
		  if (anioAux.equals(curso1))
		  {
			if (numeroTitulados.anio1!=null) //Año academico actual
			{
			numeroTitulados.anio1 = numeroTitulados.anio1+1;
			total.totalCurso1Bilbao++;
			}
			else
			{
			numeroTitulados.anio1 = 1;
			total.totalCurso1Bilbao++;    
			}
		  }
		  else if (anioAux.equals(curso2)) //Año academico - 1
		  {
			if (numeroTitulados.anio2!=null)
			{
			numeroTitulados.anio2 = numeroTitulados.anio2+1;
			total.totalCurso2Bilbao++;
			}
			else
			{
			numeroTitulados.anio2 = 1;
			total.totalCurso2Bilbao++;
			}
		  }
		  else if (anioAux.equals(curso3)) //Año academico - 2
		  {
			if (numeroTitulados.anio3!=null)
			{
			numeroTitulados.anio3 = numeroTitulados.anio3+1;
			total.totalCurso3Bilbao++;
			}
			else
			{
			numeroTitulados.anio3 = 1;
			total.totalCurso3Bilbao++;
			
			}
		  }
		  
		  solis1.put(myObject.Titulacion,numeroTitulados);  
		}
		else //No tenemos la titulación en el map
		{    
		  if (anioAux.equals(curso1))
		  {
			myObject.anio1=1;
		  total.totalCurso1Bilbao++;
		  }
		  else if (anioAux.equals(curso2))
		  {
			myObject.anio2=1;
		  total.totalCurso2Bilbao++;
		  }
		  else if (anioAux.equals(curso3))
		  {
			myObject.anio3=1;
		  total.totalCurso3Bilbao++;
		  }    
		  
		  solis1.put(myObject.Titulacion,myObject);          
		}
		}      
		//Lo mismo pero para el campus de Donosti
		if (query.Matriculado_en__r.Campus__c=='1')
		{              
		  if (solis2.get(myObject.Titulacion)!=null)
		  {
		  GroupedQuery numeroTitulados = solis2.get(myObject.Titulacion);
		  if (anioAux.equals(curso1))
		  {
			if (numeroTitulados.anio1!=null)
			{
			numeroTitulados.anio1 = numeroTitulados.anio1+1;
			total.totalCurso1Donosti++;
			}
			else
			{
			numeroTitulados.anio1 = 1;
			total.totalCurso1Donosti++;
			}
		  }
		  else if (anioAux.equals(curso2))
		  {
			if (numeroTitulados.anio2!=null)
			{
			numeroTitulados.anio2 = numeroTitulados.anio2+1;
			total.totalCurso2Donosti++;
			}
			else
			{
			numeroTitulados.anio2 = 1;
			total.totalCurso2Donosti++;
			}
		  }
		  else if (anioAux.equals(curso3))
		  {
			if (numeroTitulados.anio3!=null)
			{
			numeroTitulados.anio3 = numeroTitulados.anio3+1;
			total.totalCurso3Donosti++;
			}
			else
			{
			numeroTitulados.anio3 = 1;
			total.totalCurso3Donosti++;
			}
		  }
		  
		  solis2.put(myObject.Titulacion,numeroTitulados);  
		}
		else
		{    
		  if (anioAux.equals(curso1))
		  {
			myObject.anio1=1;
		  total.totalCurso1Donosti++;
		  }
		  else if (anioAux.equals(curso2))
		  {
			myObject.anio2=1;
		  total.totalCurso2Donosti++;
		  }
		  else if (anioAux.equals(curso3))
		  {
			myObject.anio3=1;
		  total.totalCurso3Donosti++;
		  }      
		  
		  solis2.put(myObject.Titulacion,myObject);          
		}          
		}
		//Lo mismo pero para el campus de Vitoria
		if (query.Matriculado_en__r.Campus__c=='4')
		{              
		  if (solis3.get(myObject.Titulacion)!=null)
		  {
		  GroupedQuery numeroTitulados = solis3.get(myObject.Titulacion);
		  if (anioAux.equals(curso1))
		  {
			if (numeroTitulados.anio1!=null)
			{
			numeroTitulados.anio1 = numeroTitulados.anio1+1;
			total.totalCurso1Vitoria++;
			}
			else
			{
			numeroTitulados.anio1 = 1;
			total.totalCurso1Vitoria++;
			}
		  }
		  else if (anioAux.equals(curso2))
		  {
			if (numeroTitulados.anio2!=null)
			{
			numeroTitulados.anio2 = numeroTitulados.anio2+1;
			total.totalCurso2Vitoria++;
			}
			else
			{
			numeroTitulados.anio2 = 1;
			total.totalCurso2Vitoria++;
			}
		  }
		  else if (anioAux.equals(curso3))
		  {
			if (numeroTitulados.anio3!=null)
			{
			numeroTitulados.anio3 = numeroTitulados.anio3+1;
			total.totalCurso3Vitoria++;
			}
			else
			{
			numeroTitulados.anio3 = 1;
			total.totalCurso3Vitoria++;
			}
		  }
		  
		  solis3.put(myObject.Titulacion,numeroTitulados);  
		}
		else
		{    
		  if (anioAux.equals(curso1))
		  {
			myObject.anio1=1;
		  total.totalCurso1Vitoria++;
		  }
		  else if (anioAux.equals(curso2))
		  {
			myObject.anio2=1;
		  total.totalCurso2Vitoria++;
		  }
		  else if (anioAux.equals(curso3))
		  {
			myObject.anio3=1;
		  total.totalCurso3Vitoria++;
		  }      
		  
		  solis3.put(myObject.Titulacion,myObject);          
		}          
		}
		//Lo mismo pero para el campus de Bicampus
		/*if (query.Campus__c=='5')
		{              
		  if (solis4.get(myObject.Titulacion)!=null)
		  {
		  GroupedQuery numeroTitulados = solis4.get(myObject.Titulacion);
		  if (anioAux.equals(curso1))
		  {
			if (numeroTitulados.anio1!=null)
			{
			numeroTitulados.anio1 = numeroTitulados.anio1+1;
			total.totalCurso1Bicampus++;
			}
			else
			{
			numeroTitulados.anio1 = 1;
			total.totalCurso1Bicampus++;
			}
		  }
		  else if (anioAux.equals(curso2))
		  {
			if (numeroTitulados.anio2!=null)
			{
			numeroTitulados.anio2 = numeroTitulados.anio2+1;
			total.totalCurso2Bicampus++;
			}
			else
			{
			numeroTitulados.anio2 = 1;
			total.totalCurso2Bicampus++;
			}
		  }
		  else if (anioAux.equals(curso3))
		  {
			if (numeroTitulados.anio3!=null)
			{
			numeroTitulados.anio3 = numeroTitulados.anio3+1;
			total.totalCurso3Bicampus++;
			}
			else
			{
			numeroTitulados.anio3 = 1;
			total.totalCurso3Bicampus++;
			}
		  }
		  
		  solis4.put(myObject.Titulacion,numeroTitulados);  
		}
		else
		{    
		  if (anioAux.equals(curso1))
		  {
			myObject.anio1=1;
		  total.totalCurso1Bicampus++;
		  }
		  else if (anioAux.equals(curso2))
		  {
			myObject.anio2=1;
		  total.totalCurso2Bicampus++;
		  }
		  else if (anioAux.equals(curso3))
		  {
			myObject.anio3=1;
		  total.totalCurso3Bicampus++;
		  }      
		  
		  solis4.put(myObject.Titulacion,myObject);          
		}          
		}*/
	  }
	  
	  //Finalmente calculamos los totales finales.
	  total.totalUD1 = total.totalCurso1Bilbao+total.totalCurso1Donosti+total.totalCurso1Vitoria+total.totalCurso1Bicampus;
	  total.totalUD2 = total.totalCurso2Bilbao+total.totalCurso2Donosti+total.totalCurso2Vitoria+total.totalCurso2Bicampus;
	  total.totalUD3 = total.totalCurso3Bilbao+total.totalCurso3Donosti+total.totalCurso3Vitoria+total.totalCurso3Bicampus;
	  
	  //Y pasamos los maps a Listas que se relacionarán con el datatable en la pagina MatriculasSI
	  System.debug('asiereiki: '+solis1);
	  solisBilbao = new List<GroupedQuery>();
	  for(GroupedQuery soli: solis1.values())
	  {
		if(solisBilbao.size()==0)
		{
		solisBilbao.add(soli);
		}
		else
		{
		Boolean fijado = false;
		for(Integer i=0;i<solisBilbao.size();i++)
		{
		  if(solisBilbao[i].orden > soli.orden)
		  {
		  solisBilbao.add(i,soli);
		  fijado = true;
		  break;
		  }
		}                    
		if(!fijado)
		{
		  solisBilbao.add(soli);            
		}        
		}
	  System.debug('asiereiki solisBilbao: '+solisBilbao);
	  }
	  
	  solisDonosti = new List<GroupedQuery>();
	  for(GroupedQuery soli: solis2.values())
	  {
		if(solisDonosti.size()==0)
		{
		solisDonosti.add(soli);
		}
		else
		{
		Boolean fijado = false;
		for(Integer i=0;i<solisDonosti.size();i++)
		{
		  if(solisDonosti[i].orden > soli.orden)
		  {
		  solisDonosti.add(i,soli);
		  fijado = true;
		  break;
		  }
		}                    
		if(!fijado)
		{
		  solisDonosti.add(soli);            
		}          
		}
	  }
	
	  solisVitoria = new List<GroupedQuery>();
	  for(GroupedQuery soli: solis3.values())
	  {
		if(solisVitoria.size()==0)
		{
		solisVitoria.add(soli);
		}
		else
		{
		Boolean fijado = false;
		for(Integer i=0;i<solisVitoria.size();i++)
		{
		  if(solisVitoria[i].orden > soli.orden)
		  {
		  solisVitoria.add(i,soli);
		  fijado = true;
		  break;
		  }
		}                    
		if(!fijado)
		{
		  solisVitoria.add(soli);            
		}          
		}
		System.debug('Solis Vitoria: '+solisVitoria);
	  }
	
	  solisBicampus = new List<GroupedQuery>();
	  for(GroupedQuery soli: solis4.values())
	  {
		if(solisBicampus.size()==0)
		{
		solisBicampus.add(soli);
		}
		else
		{
		Boolean fijado = false;
		for(Integer i=0;i<solisBicampus.size();i++)
		{
		  if(solisBicampus[i].orden > soli.orden)
		  {
		  solisBicampus.add(i,soli);
		  fijado = true;
		  break;
		  }
		}                    
		if(!fijado)
		{
		  solisBicampus.add(soli);            
		}          
		}
	  }
	  }
	}
	
	}