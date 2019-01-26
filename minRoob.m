fid1 = fopen('in.txt','r');
fid2 = fopen('in.txt','r');
numbers=getAllNumbers(fid1);                              %numbers= All the numbers in the text file as an array of character 
patterns=getAllPatterns(fid2);                            %patterns= Cellarray of all the patterns in our text          
%%%%%%%%generating wanted output in a cellarray
u=-1;
result={};
for i=1:size(numbers,1)
    k=str2double(numbers(i,1));                           %k is the number of rows for each pattern
    if(k==0)                                              %When we get to zero we should end the operation
        break
    end
    eachpattern=[];                                       %Array of character           
    s=u+3;                                                %With s and e we can get the start and end row for each pattern
    e=s+k-1;
    for j=s:e                                             %Iterate through patterns to get eachpattern
        eachpattern=[eachpattern;cell2mat(patterns(j,:))];
    end
    result{end+1}=[countStars(eachpattern)];              %result= Cellarray of output
    u=e;
end
%%%%%%%%%putting result to an Excel file%%%%%%%%%
ca=cell(100,20);                                          %ca = 100 by 20 empty cellarray to put in Excel
j=2;                                                      %Iterate through ca
for i=1:size(result,2)
    finresult=result{1,i};                                %finresult = Final output of each pattern in result
    ca(j:j+size(finresult,1)-1,1:size(finresult,2))=finresult;%Put finresult in ca 
    ca{j-1}=['pattern #' num2str(i) ':'];                 %Number of pattern befor each result
    j=j+size(finresult,1)+1;                              %Update j for the next final result
end
xlswrite('out.xlsx',ca,'sheet1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%getAllthePatterns(fid_pattern) Gets an id for a file as an input 
%and uses regular expression to find this specific pattern in the text file
function matchStr_pattern=getAllPatterns(fid_pattern)
matchStr_pattern={};                                      %Cellarray of all the matched patterns
i=1;
while (~feof(fid_pattern))
    line=fgets(fid_pattern);                              %Reading the file line by line
    expression = '\**\.*\**\.*';                          %Expression that we are looking for
    matchStr =regexpi(line,expression,'match');           %Cellarray contains the actual text matched the expression
    matchStr_pattern{i,1}=cell2mat(matchStr);             %Self explanatory
    matchStr_pattern=[matchStr_pattern;cell2mat(matchStr)];
    i=i+1;
end
fclose(fid_pattern);                                      %Close the text file
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%getAllNumbers(fid_numbrs) Gets an id for a file as an input 
%and uses regular expression to find numbers in the text file
function matchStr_number=getAllNumbers(fid_numbrs)
matchStr_number=[];
while ( ~feof(fid_numbrs) )
    line_number=fgets(fid_numbrs);
    expression_number = '\d';                             %Regular expression for number
    matchStr_num =regexpi(line_number,expression_number,'match');
    matchStr_number=[matchStr_number;cell2mat(matchStr_num)];
end
fclose(fid_numbrs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%countStars(A) gets an array of character and counts all the stars in the
%neighborhood of each '.'
function finalp = countStars(A)
A1=char(46*ones(size(A,1)+2,size(A,2)+2));                %Generating an array of '.' with 2 more rows and columns
A1(2:2+size(A,1)-1,2:2+size(A,2)-1)=A;                    %Putting the input in the middle of that array
c=0;
for i=2:size(A1,1)-1
    for j=2:size(A1,2)-1
        if(A1(i,j)=='.')
            for k=i-1:i+1
                if(A1(k,j-1)=='*')
                    c=c+1;
                end
            end
            for k=i-1:2:i+1
                if(A1(k,j)=='*')
                    c=c+1;
                end
            end
            for k=i-1:i+1
                if(A1(k,j+1)=='*')
                    c=c+1;
                end
            end
            finalp{i-1,j-1}=c;
            c=0;
        end
        if(A1(i,j)=='*')
            finalp{i-1,j-1}='*';
        end       
    end    
end
end


