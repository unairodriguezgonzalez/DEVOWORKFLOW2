/** 
* Class TEST_CampaignControllerExtension
**
* @Autor: arodriguez (21/11/2012)
**/
@isTest
private class TEST_AccountControllerExtension {

    static testMethod void controladorTEST() {
    	
    	
    		Datetime fechaActual = datetime.now();	
			String curso1;
			String curso2;
			String curso3;
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
    	
    	Account cole = new Account(Name = 'Colegio', RecordTypeId = Constantes.TIPO_REGISTRO_CENTRO_ENSENANZA);
    	insert cole;
    	
    	Titulacion__c titu = new Titulacion__c(Name='Titu1',Orden_etiquetas__c = 1,Campus__c='0');
    	insert titu;
    	
    	Titulacion__c titu2 = new Titulacion__c(Name='Titu2',Orden_etiquetas__c = 2,Campus__c='1');
    	insert titu2;

		Titulacion__c titu3 = new Titulacion__c(Name='Titu2',Orden_etiquetas__c = 2,Campus__c='4');
    	insert titu3;

        Titulacion__c tituGral = new Titulacion__c(Name='ggral',Orden_etiquetas__c = 3, Codigo__c = 'ggral',Campus__c='0');
        insert tituGral;
    	
    	Lead candi = new Lead(FirstName='Asier', LastName='Rodriguez', RecordTypeId = Constantes.CANDIDATO_ESTUDIANTE_GRADO,Centro_de_ensenanza__c=cole.Id);
    	insert candi;
    	
    	List<Solicitud_de_admision_de_grado__c> sads = new List<Solicitud_de_admision_de_grado__c>();
    	
    	Solicitud_de_admision_de_grado__c sad1 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='1',Matriculado_en__c=titu.Id,Campus__c='0',Curso_academico__c=curso1);
    	sads.add(sad1);
    	    	
    	Solicitud_de_admision_de_grado__c sad2 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='2',Matriculado_en__c=titu.Id,Campus__c='0',Curso_academico__c=curso2);
    	sads.add(sad2);
    	    	
    	Solicitud_de_admision_de_grado__c sad3 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='3',Matriculado_en__c=titu.Id,Campus__c='0',Curso_academico__c=curso3);
    	sads.add(sad3);    	
    	
    	Solicitud_de_admision_de_grado__c sad11 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='4',Matriculado_en__c=titu2.Id,Campus__c='0',Curso_academico__c=curso1);
    	sads.add(sad11);
    	    	
    	Solicitud_de_admision_de_grado__c sad21 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='5',Matriculado_en__c=titu2.Id,Campus__c='0',Curso_academico__c=curso2);
    	sads.add(sad21);
    	    	
    	Solicitud_de_admision_de_grado__c sad31 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='6',Matriculado_en__c=titu2.Id,Campus__c='0',Curso_academico__c=curso3);
    	sads.add(sad31);
    	    	
    	Solicitud_de_admision_de_grado__c sad4 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='7',Matriculado_en__c=titu.Id,Campus__c='1',Curso_academico__c=curso1);
    	sads.add(sad4);
    	    	
    	Solicitud_de_admision_de_grado__c sad5 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='8',Matriculado_en__c=titu.Id,Campus__c='1',Curso_academico__c=curso2);
    	sads.add(sad5);
    	    	
    	Solicitud_de_admision_de_grado__c sad6 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='9',Matriculado_en__c=titu.Id,Campus__c='1',Curso_academico__c=curso3);
    	sads.add(sad6);
    	    	
    	Solicitud_de_admision_de_grado__c sad41 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='10',Matriculado_en__c=titu2.Id,Campus__c='1',Curso_academico__c=curso1);
    	sads.add(sad41);
    	    	
    	Solicitud_de_admision_de_grado__c sad51 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='11',Matriculado_en__c=titu2.Id,Campus__c='1',Curso_academico__c=curso2);
    	sads.add(sad51);
    	    	
    	Solicitud_de_admision_de_grado__c sad61 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='12',Matriculado_en__c=titu2.Id,Campus__c='1',Curso_academico__c=curso3);
    	sads.add(sad61);

		Solicitud_de_admision_de_grado__c sad7 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='13',Matriculado_en__c=titu3.Id,Campus__c='2',Curso_academico__c=curso1);
    	sads.add(sad7);
    	    	
    	Solicitud_de_admision_de_grado__c sad8 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='14',Matriculado_en__c=titu3.Id,Campus__c='2',Curso_academico__c=curso2);
    	sads.add(sad8);
    	    	
    	Solicitud_de_admision_de_grado__c sad9 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='15',Matriculado_en__c=titu3.Id,Campus__c='2',Curso_academico__c=curso3);
    	sads.add(sad9);
    	    	
    	Solicitud_de_admision_de_grado__c sad42 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='16',Matriculado_en__c=titu3.Id,Campus__c='2',Curso_academico__c=curso1);
    	sads.add(sad42);
    	    	
    	Solicitud_de_admision_de_grado__c sad52 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='17',Matriculado_en__c=titu3.Id,Campus__c='2',Curso_academico__c=curso2);
    	sads.add(sad52);
    	    	
    	Solicitud_de_admision_de_grado__c sad62 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='18',Matriculado_en__c=titu3.Id,Campus__c='2',Curso_academico__c=curso3);
    	sads.add(sad62);

		Solicitud_de_admision_de_grado__c sad10 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='19',Matriculado_en__c=titu.Id,Campus__c='5',Curso_academico__c=curso1);
    	sads.add(sad10);
    	    	
    	Solicitud_de_admision_de_grado__c sad13 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='20',Matriculado_en__c=titu.Id,Campus__c='5',Curso_academico__c=curso2);
    	sads.add(sad13);
    	    	
    	Solicitud_de_admision_de_grado__c sad12 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='21',Matriculado_en__c=titu.Id,Campus__c='5',Curso_academico__c=curso3);
    	sads.add(sad12);
    	    	
    	Solicitud_de_admision_de_grado__c sad43 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='22',Matriculado_en__c=titu2.Id,Campus__c='5',Curso_academico__c=curso1);
    	sads.add(sad43);
    	    	
    	Solicitud_de_admision_de_grado__c sad53 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='23',Matriculado_en__c=titu2.Id,Campus__c='5',Curso_academico__c=curso2);
    	sads.add(sad53);
    	    	
    	Solicitud_de_admision_de_grado__c sad63 = new Solicitud_de_admision_de_grado__c(Candidato__c=candi.Id,ID_SGA__c='24',Matriculado_en__c=titu2.Id,Campus__c='5',Curso_academico__c=curso3);
    	sads.add(sad63);
    	
    	insert sads;
    	
    	
      Test.startTest();
		PageReference pageRef = Page.MatriculasSI;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', cole.Id);
		ApexPages.standardController controller = new ApexPages.standardController(cole);
		AccountControllerExtension controllerExt = new AccountControllerExtension(controller);
		
		System.assertEquals(controllerExt.solisBilbao[0].orden,1);
		//System.assertEquals(controllerExt.solisBilbao[controllerExt.solisBilbao.size()-1].orden,2);
		
		System.assertEquals(controllerExt.total.totalCurso1Bilbao,3);
		System.assertEquals(controllerExt.total.totalCurso2Bilbao,3);
		System.assertEquals(controllerExt.total.totalCurso3Bilbao,3);
		System.assertEquals(controllerExt.total.totalCurso1Donosti,3);
		System.assertEquals(controllerExt.total.totalCurso2Donosti,3);
		System.assertEquals(controllerExt.total.totalCurso3Donosti,3);
		System.assertEquals(controllerExt.total.totalCurso1Vitoria,2);
		System.assertEquals(controllerExt.total.totalCurso2Vitoria,2);
		System.assertEquals(controllerExt.total.totalCurso3Vitoria,2);
		System.assertEquals(controllerExt.total.totalUD3,8);
		System.assertEquals(controllerExt.total.totalUD2,8);
		System.assertEquals(controllerExt.total.totalUD1,8);
		
      Test.stopTest();
		
    }
}