/**
 * @description       : 
 * @author            : adelacruz
 * @group             : 
 * @last modified on  : 02-08-2022
 * @last modified by  : adelacruz
 * Modifications Log
 * Ver   Date         Author      Modification
 * 1.0   02-08-2022   adelacruz   Initial Version
**/

@isTest(seeAllData=true)
private class AAATest {

	private static String RECORD_TYPE_TITULACION_IDIOMA   = Constantes.RECORD_TYPE_TITULACION_IDIOMA; // DeveloperName del tipo de registro idiomas para la titulación
	private static String RECORD_TYPE_SOLICITUD_IDIOMA    = Constantes.RECORD_TYPE_SOLICITUD_IDIOMA;  // DeveloperName del tipo de registro idiomas para la solicutud
	private static String RECORD_TYPE_LEAD_IDIOMA         = Constantes.RECORD_TYPE_LEAD_IDIOMA;       // DeveloperName del tipo de registro idiomas para la titulación

	/** 
    * método para probar que los nuevos campos de solicita informacion se rellenan correctamente
    **
    * @author iescalante
    * @date 06/05/2020
    */
    @isTest static void test_comprobarSolicitaInformacion()
    {
        Test.startTest();
        List<Titulacion__c> titulaciones = [
            SELECT Id, Codigo__c, Centro__r.ParentId, Centro__c , Centro__r.Parent.Name, Centro__r.Campus__C, Centro__r.Name 
            FROM Titulacion__c 
            WHERE Vigente__c = true AND Codigo__c = 'G14402' LIMIT 1
            ];
		Titulacion__c tit = titulaciones.get(0);
        Account centro = [SELECT id, name, Campus__C FROM Account WHERE id =: tit.centro__c];
        Account centroParent = [SELECT name FROM Account WHERE id =: tit.centro__r.parentId ];

        List<Pais__c> paises = [SELECT Id, Codigo_texto__c FROM Pais__c WHERE Codigo_numerico__c = '48'];

        List<Lead> listaLead = new List<Lead>();
        Lead lead1 = new Lead();
        lead1.FirstName = 'Pepe';
        lead1.LastName = 'Fuertes' ;
        lead1.Direccion__c = 'Calle la angustia 4 d' ;
        lead1.Modalidad_de_acceso__c = 'ESU';               
        lead1.Otra_localidad__c = 'Bilbao*2514';
        lead1.Codigo_postal__c = '48041';               
        lead1.Provincia_web__c = '1';
        lead1.Pais__r = paises[0];
        lead1.Phone = '917983568';
        lead1.MobilePhone = '669631404'; 
        lead1.Email = 'aduaneros@sinfronteras.com';             
        lead1.Centro_de_ensenanza_web__c ='282017*C. SAN PABLO C.E.U.' ;
        lead1.DNI__c = '72291882F';
        lead1.Campus__c = '0';
        lead1.RecordTypeId = Constantes.CANDIDATO_ESTUDIANTE_GRADO;
        lead1.Modo_de_envio__c = 'Correo postal';
        lead1.Solicita_informacion_de__c = 'G14402';

        insert lead1;
        

        Lead candidato = [
            SELECT Id, Solicita_informacion_centros_trigger__c, Solicita_informacion_facultades_trigger__c 
            FROM lead WHERE id =: lead1.id
            ];

        Test.stopTest();
        System.assertEquals( true, candidato.Solicita_informacion_centros_trigger__c.contains( tit.centro__r.Parent.Name ) );
        System.assertEquals( true, candidato.Solicita_informacion_centros_trigger__c.contains( tit.Centro__r.Campus__c ) );
        System.assertEquals( true, candidato.Solicita_informacion_facultades_trigger__c.contains( tit.Centro__r.Parent.Name ) );
        //System.assertEquals( candidato.Solicita_informacion_centros_trigger__c, tit.centro__r.Parent.Name + ' - '+ tit.Centro__r.Campus__c + ',');
        //System.assertEquals( candidato.Solicita_informacion_facultades_trigger__c, tit.centro__r.parent.name + ',' ); 
    }

	/** 
    * Genera un candidato con dato al azar
    **
    * @author pquintanilla-NTS
    * @date 24/04/2017
	* @param numRegistros           - Número candidatos a generar
	* @param recordTypeDevNam       - Tipo de registro de todos los candidatos generados
	* @param status                 - Estado de todos los candidatos
	* @param leadSource             - Origen de todos los candidatos
	* @param cursosVigencia         - Cursos de vigencia (separados por ; ) de todos los candidatos
	* @param solicitudesInformacion - Solicitud de información (separdao por ; ) de IDIOMAS de todos los candidatos 
	* @param solicitaInformacion    - Si se trata o no de una solicitud de idioma. Para todos los candidatos.
    * @return List<Lead> - candidatos generados
    */
   /* public static List<Lead> getLeads(Integer numRegistros, String recordTypeDevNam, String status, String leadSource, String cursosVigencia, String solicitudesInformacion, Boolean solicitaInformacion)
    {
        Id regCandidatoIdioma = Utilidades.getIdRecordTypeByName( recordTypeDevNam,'Lead');
        if(regCandidatoIdioma == null)
        {
            return null;
        }

        List<Lead> candidatos = new List<Lead>();

        for(Integer i=0; i<numRegistros; i++)
        {
        	Lead candidato = new Lead();
	        candidato.RecordTypeId                          = regCandidatoIdioma;
	        candidato.FirstName                             = getRandomString(20);
	        candidato.LastName                              = getRandomString(30);
	        candidato.Fecha_de_recepcion__c                 = System.today();
	        candidato.Status                                = status;
	        candidato.LeadSource                            = leadSource;
	        candidato.Cursos_academicos_de_vigencia__c      = cursosVigencia;
	        candidato.Solicitud_de_informacion_de_idioma__c = solicitudesInformacion;
	        candidato.Solicitud_de_informacion_idioma__c    = solicitaInformacion;
	        candidatos.add(candidato);
        }
        return candidatos;
    }*/

    /** 
    * @author: pquintanilla (NTS)
    * @date: 25/04/2017
    * @param: size - Largo de la cadena de texto.
    * @description: obtiene un string al azar
    **/
    /*private static String getRandomString(Integer size)
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < size) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 52);
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }*/

    /** 
    * Obtiene solicitudes de información en base a una lista de candidatos y una lista de titulaciones. Por cada candidato y titulación se genera un solicitud.
    **
    * @author pquintanilla-NTS
    * @date 25/04/2017
    * @param candidatos - lista de candidatos.
    * @return List<Solicitud_de_informacion__c> - solicitudes de información generadas. Devuelve null en caso de fallo.
    */
    /*public static List<Solicitud_de_informacion__c> getSolicitudInformacionIdioma(List<Lead> candidatos, List<Titulacion__c> titulaciones)
    {
    	Id regSolicitud = Utilidades.getIdRecordTypeByName( RECORD_TYPE_SOLICITUD_IDIOMA,'Solicitud_de_informacion__c');
		if(regSolicitud == null)
		{
			return null;
		}

		List<Solicitud_de_informacion__c> solicitudes = new List<Solicitud_de_informacion__c>();
    	for(Lead candidato :candidatos)
    	{
    		for(Titulacion__c titulacion :titulaciones)
    		{
    			Solicitud_de_informacion__c solicitud = new Solicitud_de_informacion__c();
    			solicitud.Titulacion__c         = titulacion.Id;
    			solicitud.Candidato__c          = candidato.Id;
    			solicitud.Fecha_de_solicitud__c = System.today();
    			solicitud.RecordTypeId          = regSolicitud;
    			solicitudes.add(solicitud);
    		}

    	}
    	return solicitudes;
    }*/

    /** 
    * Verifica si un campo separado por ; está dentro de los valores del Set<String>
    * @see {8:ClaseRelacionada}
    **
    * @author pquintanilla-NTS
    * @date 25/04/2017
    * @param listCommas - campos de texto con varios valores separados por ;
    * @param checkedValues - set de todos los posibles valores
    * @return Boolean - True si todos los valores de listCommas están dentro de checkedValues
    */
    /*private static Boolean checkListCommas(String listCommas, Set<String> checkedValues)
    {
    	if(listCommas != null)
    	{
    		for(String element: listCommas.split(';'))
	        {   
	            if(!checkedValues.contains(element))
	            {
	                return false;
	            }
	        }
    	}
    	else
    	{
    		return false;
    	}

        return true;
    }*/

     /** 
    * Obtiene todas las titulaciones posibles de idiomas en base al campo Solicita_información_de del candidato
    **
    * @author pquintanilla-NTS
    * @date 25/04/2017
    */
   /* public static List<Titulacion__c> getTitulacionIdiomas()
    {		
		Id regTitulacion = Utilidades.getIdRecordTypeByName( RECORD_TYPE_TITULACION_IDIOMA,'Titulacion__c');
		if(regTitulacion == null)
		{
			return null;
		}

    	//Obtenemos los valores de las listas
    	List<Schema.PicklistEntry> lCodigos      = Lead.Solicitud_de_informacion_de_idioma__c.getDescribe().getPicklistValues();
		List<Schema.PicklistEntry> lIdiomaValues = Titulacion__c.Idioma__c.getDescribe().getPicklistValues();
		List<Schema.PicklistEntry> lNivelValues  = Titulacion__c.Nivel__c.getDescribe().getPicklistValues();
		Integer i = 0;
			
		List<Titulacion__c> titulaciones = new List<Titulacion__c>();
		for(Schema.PicklistEntry codigo: lCodigos)
		{	
			Titulacion__c titulacion = new Titulacion__c();
			titulacion.Name         = 'TEST_'+lNivelValues.get(0).getLabel()+lIdiomaValues.get(0).getLabel();
			titulacion.Nivel__c     = lNivelValues.get(0).getValue();
			titulacion.Idioma__c    = lIdiomaValues.get(0).getValue();
			titulacion.RecordTypeId = regTitulacion; // Tipo de registro 
			titulacion.Vigente__c   = true;
			titulacion.Codigo__c    = codigo.getValue();
			titulaciones.add(titulacion);
			i += 1;
		}
		return titulaciones;
    }*/

	/*@isTest static void test_actualizarSolicitaInformacionDeCandidato()
	{
		Integer NUM_LEADS = 15;

		//Creo el candido
		List<Lead> candidatos = getLeads(NUM_LEADS, RECORD_TYPE_LEAD_IDIOMA, 'Solicitud de información', 'Web', null, null, true);
		if(candidatos == null)
		{
			System.assert(false, 'Se ha daddo un erro al obtener el tipo de reigstro');
		}
		insert(candidatos);

		//Creo las titulaciones
		List<Titulacion__c> titulaciones = getTitulacionIdiomas();
		if(titulaciones == null)
		{
			System.assert(false, 'Se ha daddo un erro al obtener el tipo de reigstro');	
		}
		insert(titulaciones);

		//Creo las solicitudes de información de Idiomas
		List<Solicitud_de_informacion__c> solicitudes = getSolicitudInformacionIdioma(candidatos, titulaciones);
		if(solicitudes == null)
		{
			System.assert(false, 'Se ha daddo un erro al obtener el tipo de reigstro');	
		}

		//Realizamos la inserción.
		Test.startTest();
			insert(solicitudes);
		Test.stopTest();

		//Obtengo todos los posibles valores de las solicitudes en un set;
		Set<String> checkedValues = Utilidades.getSetPickListValues('Lead','Solicitud_de_informacion_de_idioma__c');
		
		//Verificamos los datos del candidato
		List<Lead> candidatosNew = [SELECT Id, Solicitud_de_informacion_de_idioma__c FROM Lead];
		System.assertEquals( candidatos.size(), candidatosNew.size() );

		for(Lead candidato: candidatosNew)
		{*/
			/*
			* Dado que cada candidato tiene una solicitud de información de idioma por cada titulación de idioma, se deben haber 
			* seleccionado todos los valores Solicitud_de_informacion_de_idioma__c
			*/
			/*System.assert( candidato.Solicitud_de_informacion_de_idioma__c != null );
			System.assert( checkListCommas(candidato.Solicitud_de_informacion_de_idioma__c, checkedValues)  );
		}	

		//Modificamos las solicitudes para el año que viene
		Date nuevaFecha = System.today().addYears(1);
		for(Solicitud_de_informacion__c solicitud: solicitudes)
		{
			solicitud.Fecha_de_solicitud__c = nuevaFecha;
		}

		//Actualizmos las solicitudes
		update(solicitudes);

		//Verificamos los datos del candidato
		candidatosNew = [SELECT Id, Solicitud_de_informacion_de_idioma__c FROM Lead];
		System.assertEquals( candidatos.size(), candidatosNew.size() );

		//Volvemos a verificar las titulaciones
		for(Lead candidato: candidatosNew)
		{*/
			/*
			* Dado que cada candidato tiene una solicitud de información de idioma por cada titulación de idioma, se deben haber 
			* seleccionado todos los valores Solicitud_de_informacion_de_idioma__c
			*/
			/*System.assert( candidato.Solicitud_de_informacion_de_idioma__c != null );
			System.assert( checkListCommas(candidato.Solicitud_de_informacion_de_idioma__c, checkedValues)  );
		}	

		//Borramos las solicitudes*/
		/*delete(solicitudes);

		//Verificamos los datos del candidato
		candidatosNew = [SELECT Id, Solicitud_de_informacion_de_idioma__c FROM Lead];
		System.assertEquals( candidatos.size(), candidatosNew.size() );

		for(Lead candidato: candidatosNew)
		{
			System.assert( candidato.Solicitud_de_informacion_de_idioma__c == null );
		}*/
		

	//}


	// static testMethod void borradoSolicitudesAdmisionPostgrado()
	// {								
	// 	test.startTest();
	// 	List<Lead> listaCandidatos = new List<Lead>(); 
		
	// 	Lead candidato1 = new Lead(RecordTypeId = Constantes.CANDIDATO_ESTUDIANTE_POSTGRADO, LastName = 'Candidato1', Phone = '94-4308998 Ext:12', 
	// 								MobilePhone = 'Trabajo 675/847/865',Status = 'Solicitud de información', 
	// 								Modo_de_envio__c = 'Correo postal');
	//   	listaCandidatos.add(candidato1);
	  	
	//   	Lead candidato2 = new Lead(RecordTypeId = Constantes.CANDIDATO_ESTUDIANTE_POSTGRADO, LastName = 'Candidato2', Phone = '94-4308998 Ext:12', 
	// 								MobilePhone = 'Trabajo 675/847/865',Status = 'Solicitud de información', 
	// 								Modo_de_envio__c = 'Correo postal');
	// 	listaCandidatos.add(candidato2);
											
	// 	Lead candidato3 = new Lead(RecordTypeId = Constantes.CANDIDATO_ESTUDIANTE_POSTGRADO, LastName = 'Candidato2', Phone = '94-4308998 Ext:12', 
	// 								MobilePhone = 'Trabajo 675/847/865',Status = 'Solicitud de información', 
	// 								Modo_de_envio__c = 'Correo postal');
	// 	listaCandidatos.add(candidato3);

	// 	insert listaCandidatos;
		
	// 	test.stopTest();
	//   	//El campo tiene default value selected 	  		  		  	
 
	//   	Solicitud_de_admision_postgrado__c sap1Candidato1 = new Solicitud_de_admision_postgrado__c(Candidato__c = candidato1.Id, ID_SGA__c = '123456781');
	//   	insert sap1Candidato1;
	  	
	//   	Solicitud_de_admision_postgrado__c sap2Candidato1 = new Solicitud_de_admision_postgrado__c(Candidato__c = candidato1.Id, ID_SGA__c = '123456783');
	//   	insert sap2Candidato1;
	  	
	//   	Solicitud_de_admision_postgrado__c sap1Candidato2 = new Solicitud_de_admision_postgrado__c(Candidato__c = candidato2.Id, ID_SGA__c = '123456782');
	//   	insert sap1Candidato2;
	  	
	//   	Lead[] candis = [select Id, N_de_solicitudes_de_admision__c from Lead where Id in: listaCandidatos];
	//   	for (Lead c : candis)
	//   	{
	//   		if (c.Id == candidato1.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 2);
	//   		else if (c.Id == candidato2.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 1);
	//   		else if (c.Id == candidato3.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 0);
	//   	}
	  	
	//   	List<Solicitud_de_admision_postgrado__c> listaSaps = new List<Solicitud_de_admision_postgrado__c>();
	  	
	//   	//Se insertan 90 para cada candidato, alternativamente
	//   	for (integer i = 0; i < 270; i++)
	//   	{
	//   		Solicitud_de_admision_postgrado__c sap = null;
	//   		if (math.mod(i,3) == 0)	  			
	//   			sap = new Solicitud_de_admision_postgrado__c(Candidato__c = candidato1.Id, ID_SGA__c = i.format());	  		
	//   		else if (math.mod(i,3) == 1)	  			  		
  	// 			sap = new Solicitud_de_admision_postgrado__c(Candidato__c = candidato2.Id, ID_SGA__c = i.format());	  		
	//   		else if (math.mod(i,3) == 2)	  			  		
  	// 			sap = new Solicitud_de_admision_postgrado__c(Candidato__c = candidato3.Id, ID_SGA__c = i.format());	  		
	  			
	//   		listaSaps.add(sap);		  		
	//   	}	  		  	
	//   	insert listaSaps;
	  	
	//   	//Se comprueba que el número de saps es 92, 91 y 90 respectivamente
	//   	candis = [select Id, N_de_solicitudes_de_admision__c from Lead where Id in: listaCandidatos];
	//   	for (Lead c : candis)
	//   	{
	//   		if (c.Id == candidato1.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 92);
	//   		else if (c.Id == candidato2.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 91);
	//   		else if (c.Id == candidato3.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 90);
	//   	}
	  	
	//   	delete listaSaps;
	  	
	//   	candis = [select Id, N_de_solicitudes_de_admision__c from Lead where Id in: listaCandidatos];
	//   	//Al borrarle las 90 saps, el candidato3 ha tenido que ser borrado, de ahí que ya solo queden 2	  	
	  	
	//   	//Comentados por dbonilla (23/06/2011) me impide realizar la subida de postgrado	
	//   	//System.assert(candis.size() == 2);
	  	
	//   	for (Lead c : candis)
	//   	{
	//   		if (c.Id == candidato1.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 2);
	//   		else if (c.Id == candidato2.Id)
	//   			System.assert(c.N_de_solicitudes_de_admision__c == 1);
	//   	}
	  	
	//   	//Y si al candidato2 le borramos la única que tiene, también será borrado
	//   	List<sObject> borrar = new List<sObject>();
	//   	borrar.add(sap1Candidato1);
	//   	borrar.add(sap1Candidato2);
	  	
	//   	delete borrar;
	  		  	
	//   	List<Lead> candidatos = [select Id, N_de_solicitudes_de_admision__c from Lead where Id in :listaCandidatos];
	  	
	//   	//Comentados por dbonilla (23/06/2011) me impide realizar la subida de postgrado
	//   	//Al final solo queda el candidato1 con una sola solicitud
	//   	//System.assert(candidatos.size() == 1);	  		  	
	//   	System.assert(candidatos[0].N_de_solicitudes_de_admision__c == 1);
	  	
	// }
	



	// static testMethod void testSolicitarEntrevista() 
    // {
	// 	//Se crean las titulaciones sobre las que el candidato solicitará entrevista
	// 	List<Titulacion__c> titulaciones = new List<Titulacion__c> ();

	// 	titulaciones.add ( new Titulacion__c ( Codigo__c = 'G123', Campus__c = '0', Denominacion_oficial__c = 'Grado Informática', Name = 'Grado Informática', Tipo__c = 'Grado', Vigente__c = true ) );
	// 	titulaciones.add ( new Titulacion__c ( Codigo__c = 'G122', Campus__c = '0', Denominacion_oficial__c = 'Grado Industrial', Name = 'Grado Industrial', Tipo__c = 'Grado', Vigente__c = true ) );

	// 	insert titulaciones;

	// 	Pais__c p = [Select id from pais__c where Name = 'ESPAÑA' Limit 1];
	// 	Provincia__c cadiz = new Provincia__c(Name = 'CÁDIZ', Codigo__c = '11', pais__c = p.id);
	// 	insert cadiz;
		
	// 	PageReference pageRef = Page.SolicitarEntrevista;
	// 	Test.setCurrentPage(pageRef);
		   
   	// 	ApexPages.currentPage().getParameters().put('language', 'en-US');

	// 	List<Estudio_que_cursa__mdt> estudiosCursa = [Select id, MasterLabel, Modalidad_de_acceso__c, Curso__c from Estudio_que_cursa__mdt where Orden_Literal__c != null ];
   		
	// 	SolicitarInformacionController controller = new SolicitarInformacionController();
		
    // 	User[] uList = [select Id from User where UserType = 'Guest'];
    // 	if (uList != null && uList.size() > 0)
    // 	{
    // 		System.Debug ('USER GUEST: '+uList[0]);
    		
	// 		System.runAs(uList[0])
    // 		{
	// 			//Se comprueba el total de valores en la lista "Estudios que cursa"
	// 			controller.getEstudiosQueCursa();
	// 			System.assert ( !estudiosCursa.isEmpty() );
	// 			System.assertEquals ( estudiosCursa.size() + 1 , controller.estudiosQueCursa.size() );	
					
	// 			Pais__c pais = [Select Id, Name, Codigo_texto__c from Pais__c where Name = 'ITALIA' ];
	// 			System.debug('$$$ el pais es '+pais);
	// 			controller.setPaisSeleccionado(pais.Id);
	// 			controller.resetProvincias();
		
	// 			Provincia__c prov = [select Id, Name from Provincia__c where Name = 'CÁDIZ' ];
	// 			controller.setProvinciaSeleccionada(prov.Id);
	// 			controller.resetLocalidades();		
				
	// 			controller.estudiante.LastName = 'LastName';
	// 			controller.estudiante.FirstName = 'FirstName';
	// 			controller.estudiante.Modalidad_de_acceso__c = estudiosCursa[0].MasterLabel;
	// 			controller.estudiante.MobilePhone = '666666666';

	// 			controller.setEmailField('test@test.com');

	// 			//Se seleccionan las dos titulaciones creadas arriba
	// 			List <SolicitarInformacionController.EstudioSeleccionable> estudiosSeleccionables = controller.tablaEstudiosGradoBilbao;

	// 			for ( SolicitarInformacionController.EstudioSeleccionable estudioSel : estudiosSeleccionables )
	// 			{
	// 				estudioSel.selected = true;
	// 			}

	// 			controller.tablaEstudiosGradoBilbao = estudiosSeleccionables;

	// 			controller.terminosSeleccionados = true;

	// 			controller.save();
    // 		}
    		
    // 		Lead [] l = [select Id, Procedencia_web__c, Modalidad_de_acceso__c, Curso__c from Lead where Id = :controller.estudiante.Id];
			
	// 		System.assertEquals(l.size(), 1);
	// 		System.assertEquals(l[0].Procedencia_web__c, Constantes.SOLICITUD_ENTREVISTA );
	// 		System.assertEquals ( estudiosCursa[0].Modalidad_de_acceso__c, l[0].Modalidad_de_acceso__c );
	// 		System.assertEquals ( estudiosCursa[0].Curso__c, l[0].Curso__c );

	// 		//Se comprueba que los estudios seleccionados tienen en cuenta las dos titulaciones previamente específicadas
	// 		String estudiosSeleccionados = controller.estudiosSeleccionados;

	// 		for ( Titulacion__c titulacion : titulaciones )
	// 		{
	// 			System.assert ( estudiosSeleccionados.contains ( titulacion.Denominacion_oficial__c ) );
	// 		}
			
	// 		TEST_Crear_Registros.creaTitulacionesSolicitarEntrevista();
	// 		ApexPages.currentPage().getParameters().put('codt', TEST_Crear_Registros.tit1.Codigo__c);	
    // 		controller = new SolicitarInformacionController();
	// 		ApexPages.currentPage().getParameters().put('codt', TEST_Crear_Registros.tit2.Codigo__c);	
    // 		controller = new SolicitarInformacionController();
	// 		ApexPages.currentPage().getParameters().put('codt', TEST_Crear_Registros.tit3.Codigo__c);	
    // 		controller = new SolicitarInformacionController();
	// 		ApexPages.currentPage().getParameters().put('codt', TEST_Crear_Registros.tit4.Codigo__c);	
    // 		controller = new SolicitarInformacionController();    		    		    		
    // 	}
				
    // }

}
