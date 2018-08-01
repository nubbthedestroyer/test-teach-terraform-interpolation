# Mike's Tangent - Terraform Interpolation
#### *Prepared and Taught by Michael Lucas*
[Accompanying Slides](https://docs.google.com/presentation/d/1Nfa843wN4A6-NQLYvqzfE4bwd_gREKOrIe-bniCemlk/edit?usp=sharing)

## Introduction

Welcome to Mike's Tangent.  Where we take a sideways step into a parallel dimension
relative to the main lesson to cover a nifty and related topic. 

In this brief session, we are going to learn about Interpolation within Terraform 
and how its used to extend the capability of Terraform configuration files.  Before we
begin, there are a few topics that you should know first if you don't already:

1. Hashicorp Configuration Language - Basics
    * https://www.terraform.io/docs/configuration/syntax.html
2. Terraform Variables
    * https://www.terraform.io/docs/configuration/variables.html
3. Terraform Data Structures
    * https://www.terraform.io/docs/configuration/syntax.html
4. Basic terminal operations.
5. Basic Git experience.
6. (Optional)  Basic software development experience.
    
We also assume the following:

1. You have a computer that is terminal capable that you can run commands on.
2. You've "git clone"'d this repo so you have the examples local to your terminal.
3. You've installed Terraform on your local machine.
    * https://www.terraform.io/downloads.html

If you have any questions about the above topics, bring them up during the lesson.  
Tangent questions are fun and you never know who was thinking about asking the same thing.

## WHAT (are we going to do)

We are going to perform a set of exercises to experiment with the interpolation function in Terraform. 
But first, **WHAT IS INTERPOLATION???**

Interpolation is a function in Terraform's configuration language that allows it to process text and 
data objects in more advanced ways than conventional config files, mainly manifested as a variable 
replacement within an HCL stanza that is replaced at render time with its evaluated data.  
What are some examples of what we can do with Interpolation?

- Simple math
- Network subnet calculation (super useful when using with provisioners or to simplify user input)
- Reference user input in multiple places in HCL files.
- Lookup keys and values in a map or list elements by position.
- Perform conditional logic for based on primitive types (==false/true, is>x, etc.)
- Merge lists
- Read contents from file
- JSON or Base63 encode.
- many more

In this exercise, we will play with a few of these examples to give you a feel for Interpolation.

## Setup

This repo is fully equipped with functioning Terraform to allow you to play with interpolation.  
That being said, there are a few things we need to do to prepare:

1. Ensure you've cloned this repo to your local computer and you are in the root directory for the repo 
you've just cloned.
2. Run the following command to initialize this terraform directory and pull the TF provider's you'll need.

```bash
terraform init
```

If you were successful, you'll see:

> Terraform has been successfully initialized!

## Simple Math

OK! Let's dive in!

Firstly, open the "interpolation.tf" in your favorite text editor and have a look at the contents.  The 
bottom part is designed to allow you to see the results of your interpolation in your terminal, which is 
approximately the easiest way to experiment with interpolation.

As is, this script is taking an input variable from variables.tf and outputting it directly to terminal.  
We are going to get a little fancier and demonstrate how we can do more with variables and data types with 
interpolation.

First run this commmand:

```bash
terraform apply
```

When asked for input, type "yes" without quotes.

In your output you should see the following:

```
null_resource.local_output (local-exec): === OUTPUT FROM EXPERIMENT >>> TESTING MY OUTPUT
```

This is the line that will be containing your output.  Look for this line in future sections.

So let's do some simple math.  In this case, we are going to plug in height and length to get 
the area of a square, because this is what nerds do.

In the experimentation section of interpolation.tf, copy the following:

```hcl-terraform
length = 11
height = 86
area = "${local.length * local.height}"
```

Then find the following line:

```hcl-terraform
outputfinal = "${var.testout}"
```

Change 'var.testout' to 'local.area'.

Then go back to terminal and run:

```bash
terraform apply
```

If you see the following line in the output of terraform apply:

```
null_resource.local_output (local-exec): === OUTPUT FROM EXPERIMENT >>> 946
```

Then you were successful!!!  Give yourself a pat on the back, continue to be nerdy and test this 
with different values.  Unfortunately, some more advanced math like trig is not possible 
until Hashicorp releases the new version of HCL, which will support floats better.

## Network Subnet Calculation

Let's say we have a linux server that we need to pass some special network information to.  Let's 
say we need to pass an IP address and subnet mask to a vm, but we don't know what this information 
is because we haven't been given the CIDR range.  This is less of a concern with AWS as the 
addressing is dynamic but it could feasibly be a consideration in a VMWare environment or other 
custom use case.  You never know and I want you to be ready for anything.  :-)

Go back to your experimentation block and remove or comment out our math fun.  Then enter the 
following into the block:

```hcl-terraform
cidr_range = "10.0.0.0/16"
subnet_mask = "${cidrnetmask(local.cidr_range)}"
ip_address = "${cidrhost(local.cidr_range)}"
```

and change your "outputfinal" variable to this:

```hcl-terraform
outputfinal = "IP is = ${local.ip_address} and MASK is = ${local.subnet_mask}" 
```

We are defining an IP range in CIDR notation and pulling the network mask and a valid IP 
address from the range, regardless of what the range might be.  You can imagine this would be 
a nightmare to do with splits and string manipulation.  Send Hashicorp a postcard for this 
super nifty tool!  You can then take the output of this and use it in a provisioner or output 
to an ansible template, and if you are making a module you don't need to know the CIDR range to 
make sure your config scripts are aligned to the network.  The possibilities are endless!

## Variable Substitution in File

So let's say you've defined some infrastructure in AWS and you now need to configure the operating 
system of an instance you just launched.  AWS has this concept of userdata that allows you to execute 
arbitrary code on instance launch.  Great!  But how do we get the scripts aligned with our Terraform?

If you need to get output from your Terraform into the userdata script (like an instance ID for 
example) it might feel a little like the chicken and the egg, necessitating that you run Terraform 
first, get the output, add it to your script, and then run it again to get the right data in.  Fortunately 
our friends over at Hashicorp have thought of this as well and have added a "Template File" provider.

The way this works is you specify a file that contains your text with demarcations for variable 
substitution.  

I've placed a template string in this repo that contains the following text:

```bash
echo "${message}"
```

We are going to hoover this into a variable in terraform by adding the following to our interpolation.tf 
file, just after the last '}' in the "locals" stanza, and before the "resource" stanza for the 
local_output.  You should see a designated space for it.

```hcl-terraform
data template_file {
  template = "${file("${path.module}/script.sh.tpl")}"
  vars {
    message = "HELLO WORLD"
  }
}
```

Next we just need to update the outputfinal local variable to display the rendered script.

```hcl-terraform
outputfinal = "${data.template_file.script.rendered}"
```

Then we need to run this again because we've introduced a new provider to the mix.

```bash
terraform init
```

Done right, you should see the script's output in your terminal window when you run terraform apply:

```
null_resource.local_output (local-exec): === OUTPUT FROM EXPERIMENT >>> echo HELLO WORLD
```

*** trigger dino timer ***

That concludes this episode of Mike's Tangent.  Thank you so much for listening in!

