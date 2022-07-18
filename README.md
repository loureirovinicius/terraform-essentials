# Terraform Resources (lines 13-21)
A resource is the main element from Terraform. A resource describes your infrastructure objects and is written as a block.

# Terraform Meta-arguments

## Lifecycle Rules (lines 23-39 from main_structure.tf):
Since Terraform works with immutable infrastructure, every time you need to change the state of your infrastructure, it will destroy the resource changed and recreate it with the new properties previously set. But what if we want determine what will be the order of this process?
For example, imagine you have an instance running your webservers (NGINX, Apache, etc) and you updated their versions. You'll need to apply it now, right? But what if you want to create the new instances before destroying the older ones (since this can prevent downtimes)? That's when a Lifecycle rule will help you.
[Docs](https://www.terraform.io/language/meta-arguments/lifecycle)

## Resource Dependency (lines 17-20 from main_structure.tf):
It is common to have dependency among resources since we may need to create some resources before others, and we can declare these dependecies explicitly or implicitly.
The explicit dependency is declared with the meta argument "depends_on". This meta argument accepts a list of resources that must be created before the dependant resource.
The implicit dependecy is declared when we use another resource's attribute as a value for a resource.
[Docs](https://www.terraform.io/language/meta-arguments/depends_on)

## Count (lines 52-59 from main_structure.tf)
When working with Terraform, we will probably need to create a certain resource more than once. That's when the "count" meta-argument comes in. This meta-argument will receive a number value or a built-in function and will repeat same action x times, according to the number value passed to it. To use its returned value, you can make use of the "count.index" statement and it will return the current iteration index.
The use of built-in functions are really common, like the "length" function. Imagine that you have a list variable and want to create resources with the values of this list. It wouldn't be a good practice changing the amount of iterations it would have to do, right? In this case, we would use the "length" function to get the length of the list variable and use it as the value to our count meta-argument.
[Docs](https://www.terraform.io/language/meta-arguments/count)

## For-each
The for-each meta-argument works just like "count", but they have some differences and it's important to know them for a better usage in the future.
The first difference is: the for-each value must be of type "set" or "map" (in the following lines you will find out why). So, in case you try to use a list value or any different type, you will get an error and won't be able to create your resources. But you might be wondering: "if I have a giant list variable with names, do I need to set it again, but now as a set or a map?" Well, the answer is yes and no.
If you have any case like this, you can obviously recreate the variable as a set or a list, but in case you don't want it, for many reasons, you can use these two built-in functions to change its type: toset() and tomap(). Both of these will parse your list variable to a map or a set. :)
But now anwsering the reason why you can't use any other type than a set or a map: differently from "count", the "for-each" meta-argument doesn't work with indexes. It will create a map object (with key-value pairs) and reference its key and value (in case it's a map type variable) or a value (in case it's a set type variable).
The important thing to remember here is that for this meta-argument you can only use "map" or "set" variables and that the return (output) is going to be of type "map" (key-value pair).
If you're using a "set" type variable in a for-each, both "each.key" and "each.value" are going to return a value. Using a "map" type we have the expected behavior, that is: "each.key" for keys and "each.value" for values.
[Docs](https://www.terraform.io/language/meta-arguments/for_each)

# Terraform Data Sources (lines 41-50 from main_structure.tf)
When working with infrastructure, we may already have some resources created manually inside a provider (AWS, GCP, Azure and etc), and then we want to **READ** some data from these resources that aren't managed by Terraform config files. But how would we do this if we don't have any Terraform file linked to this resource? We can use a Terraform element called Data Sources.
Data Sources allow us to **read** data from a resource that hasn't been created by Terraform. It is as simple as creating a resource, you just need to set it in the config file and then you'll be able to read (only read) data from an "outsider" resource. If you need to use the data that was read, you can use the following structure to combine it with other resources: "data.resource_type.resource_name.attribute". You can find all the attributes available in the provider's docs.
[Docs](https://www.terraform.io/language/data-sources)

# Terraform Version Constraints (lines 1-8 from backend_structure.tf)
Imagine that we're using the latest version of a resource and then we find a bug related to this version. We would like to change it, right? That's why version constraints exists.
Version Constraints allow us to use any available version of a resource, we just need to specify it somewhere. We can specify it by making use of the "terraform" block. This block is followed by another block called "required_providers" and then, a provider name block followed by the arguments "version" and "source" (an address from registry to this resource).
Also, when using the argument "version" we can specify some conditions for Terraform to follow when looking for a certain version. These conditions are defined using **operators** and can be found in Terraform's doc. Check it out if you need it.
[Docs](https://www.terraform.io/language/expressions/version-constraints)

# Terraform State and State Locking (lines 10-14 from backend_structure.tf)
In Terraform, a backend is responsible for storing its currently state. The default configuration of Terraform is to use a local backend and store the state in the "terraform.tfstate" file. Everytime we make a change and run "terraform apply", it will store these changes to this file on our local disk.
This approach may work pretty well if we're working only by ourselves and don't have any concerns about security, infrastructure delivery and other parameters. But when we take Terraform to a company and it's necessary to work on a team and have concerns about security, deployments and etc, a different approach is necessary.
Terraform offers to us different types of backends (remote, consul, s3, etc) so we can keep our state secure and provide a better way to work with our team. When changing our backend configuration, Terraform won't persist the state on disk (except for errors, check docs) and our current state will be available to anyone with access to that bucket (s3), consul and etc.
[Docs](https://www.terraform.io/language/state/backends)

## State Locking
State Locking is a useful and important resource that we can use to bring more security and organization. With state locking we can keep our state from any future changes that may occur and prevent state corruption.
It is important to know that some backends don't offer the possibility of state locking, so check docs for more information.
[Docs](https://www.terraform.io/language/state/locking)

# Provisioners (lines 56-80 from main_structure.tf)
Provisioners are used to perform specific action inside the machine provisioned by Terraform or the machine executing Terraform. In a simple and abstract way, a provisioner is a tool to execute commands inside your resource (like Linux commands).
There are 3 built-in provisioners that are commonly used, they are: local-exec (executes commands on local machines), remote-exec (executes commands in your instances created with Terraform) and file (used to copy files from the machine running Terraform to a new resource). We can have different provisioners by installing them as plugins, but that's not recommended.
Although provisioners may seem useful (which they actually are), Hashicorp advises you to use it as the last resource, and it's important to read its docs to see why they don't recommend it.
When using the "remote-exec" provisioner we need to declare a "connection" block. This block is used to set the connection between the local machine and the provisioned machine, like a SSH/WinRM connection.
Provisioners can't refer to their parent resource by its name, like: "echo ${resource_type.resource_name.ip}", instead, we need to use the "self" object. Like this: "echo ${self.public_ip}
[Docs](https://www.terraform.io/language/resources/provisioners/syntax)

## Provisioners behaviors (lines 82-100 from main_structure.tf):
We can set some behaviors to provisioners, in order to specify their order of execution, their life cycle and etc.
The first configuration we have is the "when = destroy" behavior, that applies a rule to only run a provisioner when the resource is destroyed.
The second configuration is the "on_failure" that can receive both "fail" or "continue" values. The "fail" value (default) establishes that, if the provisioner fails during it's execution, the resource won't be applied. The "continue" value says that, even if the provisioner fails, the resource will continue to be created.
[Docs](https://www.terraform.io/language/resources/provisioners/syntax)

# Tainted Resources:
Whenever you run "terraform apply" and a resource creation fails for any reason, Terraform will mark it as "tainted". Tainted might still be created, but they will be replaced after you run "terraform apply" again, in order to fix the problems found on the previous execution.
A resource also can be untainted if you want, you just need to execute the command "terraform untaint resource_type.resource_name".
For Terraform v0.15.2, it is recommended to use "terraform apply -replace=resource_type.resource_name" instead of taint, because it will reflect in the "terraform plan" and you will be able to see the impacts of this change to your infrastructure.
[Docs](https://www.terraform.io/cli/commands/taint)

# Debbuging in Terraform:
Although Terraform provides us a great set of information about our resources creation when planning/applying them, sometimes it's necessary to go deeper and investigate what are the causes of some errors/behaviors.
To do this, we can set an env variable provided by Terraform specifically for log tracing, this variable is the "TF_LOG". You can set 5 values to this variables, and each value decreases verbosity of output, the values are (in order of increasing verbosity): ERROR, WARN, INFO, DEBUG, TRACE.
To store these logs somewhere you want, use the env variable "TF_LOG_PATH", followed by the desired path.
If you want, you can disable both actions by unsetting the variables.
[Docs](https://www.terraform.io/internals/debugging)

# Terraform Import:
Let's suppose we already have some resources running in your cloud provider but they aren't in your config files, since we've just started using Terraform. What can we do to manage this resources using Terraform?
We've seen that we can use data sources to **read** data from this resources, but now if we want to manage them, we will need to use "terraform import".
The "terraform import" command firstly adds the resource to the Terraform state file and then we need to add **manually** the resource in our config file (like main.tf). So, if we run "terraform import" providing the details about the resource, we will get an error saying that the resource doesn't exist in the config file. That's why we need to add it manually. To fix this error, we need to add the resource in our config file, and it is important to say that, if we don't pass any arguments to our resource (required or optional), it will work anyway because Terraform is worried if it exists in the config file or not. So, feel free to add it empty and then later add its arguments. 
When we run "terraform import", we need to provide some details about the resource we're about to manage. These details are the resource type, resource name and an attribute that identifies that resource as unique (like an ID). For example: terraform import aws_instance.instance1 i-123456789.
[Docs](https://www.terraform.io/cli/import)

# Terraform Modules (lines 102-117 from main_structure.tf):
By now, we know that Terraform makes infrastructure management easier, but just like any other tool, when it gets bigger (dealing with great number of infrastructure), it can leads us to a certain file complexity since we're writing everything inside just one single file. For cases like this, Terraform gives us a tool called "module".
A module in Terraform is simply just configuration files separated from others and that can be imported into our "main.tf" file, which will be responsible for creating all the resources specified by the modules.
When working with modules, our **root module** will be the folder where we execute all commands, the other folders in our project are called **child modules**.
We can also use modules built by other members of the community, and they can be found in Terraform's registry.
[Docs](https://www.terraform.io/language/modules)

# Terraform Workspaces (lines 119-123 from main_structure.tf):
Workspace is a tool provided by Terraform so we can work easier within many different environments.
Let's suppose we have two environments: production and testing. Now, we want to apply the same resources (instances, IAM, etc) for both environments but we want to do this without code repetition, which is something that Terraform and other IaC tools try to solve. How would we do that?
Well, that's when a workspace comes in. We can create two new workspaces to work with the same configuration file, one of the first requirements to make use of workspaces is to remove all the hard coded values from the configuration file. We need to assign variables to changable values across environments.
The "terraform.workspace" keyword is used to reference our current workspace in a config file and each workspace has its own .tfstate file.
For example: we can create a map type variable and assign two default keys to it, each one corresponding to a different workspace. Then, in the arguments that are changable according to the environment, we can assign the map type variable we've just created and use the "lookup" function to get the value according to the key passed. Our key passed to this function would be the keyword "terraform.workspace", that will reference our current workspace and get the correct value. Check the code example out for a better understanding.
[Docs](https://www.terraform.io/language/state/workspaces#when-to-use-multiple-workspaces)

# Terraform Conditional Expressions:
Just like in programming languages, Terraform allows us to use conditional expressions. A conditional expression in Terraform is expressed the same way as a ternary if in programming languages. It is important to remember that Terraform also has logical and arithmetic operators.
Here is the structure of a conditional expression: condition ? true_value : false_value
[Docs](https://www.terraform.io/language/expressions/conditionals)

# Terraform useful functions:
Terraform has some built-in functions that can be useful in many situations, let's see some of them.
It is important to know that Terraform provides us a really cool tool to try what a function does. This tool is used as a CLI command, we just need to type "terraform console" and we're using it.
What this tool does is: it reads the content inside our .tf files and allows us to test functions using these stored variables (like a variable inside variables.tf).
Example: we can type "toset(var.names)" and we'll see the output of this function when using that variable value.
[Docs](https://www.terraform.io/language/functions)

## File:
The file function is used when we want to read data from a given file. We just need to declare it inside a resource block and pass the file path to it.

## Length:
We've seen the length function before, but it is important to remember, since it's really useful when working with lists or maps. This function determines the number of elements inside of these two types (list and map).

## To set:
The "toset()" function is used when we want to convert a list into a set. It is important to remember that this function removes duplicated values.

## To map:
The "tomap()" is used when we need to convert a set into a map.

## Max:
We can use "max()" when we need to find the greatest number among others given.
To use variables as arguments for this function, we need to declare it and use 3 periods to represent that it needs to iterate over each number. Like this: max(var.numbers...)

## Min:
We can use "min()" when we need to find the smallest number among others given.
To use variables as arguments for this function, we need to declare it and use 3 periods to represent that it needs to iterate over each number. Like this: max(var.numbers...)

## Ceil:
The "ceil()" function accepts a floating number as argument and it will find the closest and greater number from the number passed as argument.
Example: ceil(12.3) or ceil(12.9) -> it will return 13.

## Floor:
This function looks like the "ceil()" one, but now it will find the closest and smaller (or equal to) number from the number passed as argument.
Example: floor(12.3) or floor(12.9) -> it will return 12.

## Split:
This function is used to separe a string using a common separator. It will return the values in a list type variable.
Example: the string is "instance1, instance2, instance3" -> split(",", var.instances) -> it will return a list like this "\[instance1, instance2, instance3]" 

## Lower:
When we want to pass a string to lower case, we can use the "lower()" function.
Example: the string is "HI" -> lower(var.hi) will return "hi".

## Upper:
The "upper()" function has the opposite behavior of the "lower()" one, but it converts the string to upper case.
Example: the string is "hi" -> upper(var.h1) will return "HI". 

## Title:
The "title()" function converts each first letter of a word to upper case.
Example: "instance1, instance2, instance3" -> title(var.instances) will return "Instance1, Instance2, Instance3"

## Substr:
The "substr(string, offset, length)" function is used to extract part of a string given as argument. Where the "offset" is the position where the string you want to extract begins and the "length" is the compriment of the string you want to extract. 
Example: "hello Terraform" -> substr(var.hello, 0, 5) will return "hello".

## Join:
We saw that the "split()" function separes a string and returns a list containing all the values. The "join()" function does the opposite, it receives a list as argument and returns a string with all the values from that list.
Example: \["instance1", "instance2", "instance3"] -> join(",", var.instances_list) will return "instance1, instance2, instance3".

## Index:
This function is used when we want to know the index of a value in a set or map variable.
Example: \["instance1", "instance2", "instance3"] -> index(var.instances_list, "instance2") will return 1.

## Element:
Now, "element()" is the opposite of "index()", because we pass an index as argument to find out the value of it.
Example: \["instance1", "instance2", "instance3"] -> element(var.instances_list, 2) will return "instance3".

## Contains:
To check if we a specific value is present in a list, we use the "contains()" function.
Example: \["instance1", "instance2", "instance3"] -> contains(var.instances_list, "instance1") will return true.

## Keys:
The "keys()" function is used to get only the keys from a map type variable. They're returned in a list.
Example: {"key1" = "value1", "key2" = "value2", "key3" = "value3"} -> keys(var.map_variable) -> return \["key1", "key2", "key3"]

## Values:
The "values()" function is used to get only the values from a map type variable. They're returned in a list.
Example: {"key1" = "value1", "key2" = "value2", "key3" = "value3"} -> values(var.map_variable) -> return \["value1", "value2", "value3"]

## Lookup:
To look up a specific value of a key in a map type variable, we use the "lookup()" function. If the key provided to this function isn't available, it will return an error. Optionally we can pass a third argument to it with a default value to return in case the key doesn't exist.
Example: {"key1" = "value1", "key2" = "value2", "key3" = "value3"} -> lookup(var.map_variable, "key1", "value4") returns "value1".