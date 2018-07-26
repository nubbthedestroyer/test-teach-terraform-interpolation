# Mike's Tangent - Terraform Interpolation
#### *Prepared and Taught by Michael Lucas*

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

> terraform init

If you were successful, you'll see:

> Terraform has been successfully initialized!

## Simple Math

OK! Let's dive 