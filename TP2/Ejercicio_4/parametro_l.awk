BEGIN{
  FS=" "
  lineasLeidas=0
  printf("Nombre archivo\t\t\t\t\t\tTamaño original \n\n")
}
{
  if(lineasLeidas > 2 && lineasLeidas < cantidadLineasArchivo - 2)
  {
    printf("%-60s \t %d\n",$8,$1)
    
    
  }
  lineasLeidas++;
  if(lineasLeidas == cantidadLineasArchivo)
    tamanioTotal = $1
}
END{
  printf("\n Tamaño total \t\t\t\t\t\t\t%d\n", tamanioTotal)
}