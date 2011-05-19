component extends="mxunit.framework.TestCase"{

	public void function setUp() {
	
		dump();
		abort;
	
		variables.Reactor = CreateObject("Component", "reactor.reactorFactory")
			.init("/tests/config/reactor.xml");

	}

	
	function tearDown() {
	
	}



	function testSetup(){
	
		assert(isObject(variables.Reactor));
	}
}
