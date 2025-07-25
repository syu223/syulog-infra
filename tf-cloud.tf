terraform { 
  cloud { 
    
    organization = "syu-terraform" 

    workspaces { 
      name = "syulog" 
    } 
  } 
}
