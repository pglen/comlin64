apt list --installed | awk -F "/" '{print($1)}' 
