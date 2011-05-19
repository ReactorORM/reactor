component extends="mxunit.framework.TestCase"{

	public void function setUp() {
		

	}

	
	function tearDown() {
	
	}

	function testEmptyConfig(){
		
		//This should fail as it is an empty config, and we don't know what type we should be testing
		try{
			var Reactor = CreateObject("Component", "reactor.reactorFactory").init("/tests/config/empty_config.xml");
			fail("Configuration should have thrown an error");	
		}
		catch(Any e){
			assert(FindNoCase(e.type, "reactor.config.InvalidConfigXML"), "Config doesn't check for the nodes to be available");			
		}
	}
	
	
	function testORMConfig(){
		var Reactor = CreateObject("Component", "reactor.reactorFactory").init("/tests/config/orm_config.xml");
	}
	
}
