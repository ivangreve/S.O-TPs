BEGIN{
  FS=" " #separador de campos
  lineasLeidas=0
  printf("Nombre archivo\t\t\t\t\t\tTam. comprimido Tam. original Ratio compresion\n\n")
}
{
  if(lineasLeidas > 2 && lineasLeidas < cantidadLineasArchivo - 2)
  {
    printf("%-60s \t %d\t %d\t \t%d%\n",$8,$3,$1,$4)
    
    
  }
  lineasLeidas++;
  if(lineasLeidas == cantidadLineasArchivo)
    tamanioTotal = $1
}
END{
  printf("\n Tamaño total \t\t\t\t\t\t\t%d\n", tamanioTotal)
}