<cfcomponent hint="I am a CFC used to manage Java Arrays.">

	<cffunction name="createJavaArray" access="public" hint="I create and return a Java Array of the specified type." output="false" returntype="any">
		<cfargument name="typeName" hint="I am the type of array to create." required="yes" type="string" />
		<cfargument name="size" hint="I am the size of the array to create." required="yes" type="numeric" />

		<cfset NewArray = createObject("java", "java.lang.reflect.Array").newInstance(createObject("Java", "java.lang.Class").forName(arguments.typeName), arguments.size) />
		<cfreturn NewArray />
	</cffunction>
	
	<cffunction name="setJavaArray" access="public" hint="I set an element in a java array." output="false" returntype="void">
		<cfargument name="javaArray" hint="I am the Java Array to set an element of." required="yes" type="any" />
		<cfargument name="element" hint="I am the element in the array to set." required="yes" type="numeric" />
		<cfargument name="value" hint="I am the value to set the array element to." required="yes" type="any" />
		
		<cfset createObject("java", "java.lang.reflect.Array").set(arguments.javaArray, JavaCast("int", arguments.element), arguments.value) />
	</cffunction>
	
</cfcomponent>