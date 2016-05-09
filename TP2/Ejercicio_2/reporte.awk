BEGIN{
split("Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec",mesesArray,"_")
}
{
  for(x=1;x<=12;x++)
  {
     #como last -F devuelve el mes en formato MMM lo muestro a entero
    if(mesesArray[x] == $5)
    {     
      printf ("%-30s %02d/%02d/%02d  %s\n"  ,$1,int($6) ,x, int($8), $7)
      break
    }
  }
  
}



  
  
