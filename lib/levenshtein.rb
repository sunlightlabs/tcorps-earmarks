require 'inline'

class Levenshtein
  inline do |builder|
    builder.c "
        #include <stdlib.h>
        #include <malloc.h>
        #include <string.h>

        static int distance(char *s,char*t)
        /*Compute levenshtein distance between s and t*/
        {
          //Step 1
          int min, k,i,j,n,m,cost,*d,distance;
          n=strlen(s);
          m=strlen(t);
          if (n==0) return m;
          if (m==0) return n;
          d=malloc((sizeof(int))*(m+1)*(n+1));
          m++;
          n++;
          //Step 2
          for(k=0;k<n;k++)
          {
            d[k]=k;
          }
          for(k=0;k<m;k++)
          {
            d[k*n]=k;
          }
          //Step 3 and 4
          for(i=1;i<n;i++)
          {
            for(j=1;j<m;j++)
            {
              //Step 5
              if(s[i-1]==t[j-1])
              {
                cost=0;
              } else {
                cost=1;
              }
              //Step 6
              min = d[(j-1)*n+i]+1;
              if (d[j*n+i-1]+1 < min) min=d[j*n+i-1]+1;
              if (d[(j-1)*n+i-1]+cost < min) min=d[(j-1)*n+i-1]+cost;
              d[j*n+i]=min;
            }
          }
          distance=d[n*m-1];
          free(d);
          return distance;
        }

        "
  end
end