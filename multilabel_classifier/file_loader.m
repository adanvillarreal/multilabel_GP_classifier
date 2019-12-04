function [xdata, xlabels, ydata, ylabels] = file_loader(arfffile, xmlfile)
% file_loader receives a MULAN formatted ARFF file and XML file and returns
% the X and Y matrixes and their respective labels. More on MULAN format:
% http://mulan.sourceforge.net/datasets-mlc.html
%   INPUT:
    %   arfffile: path to ARFF file
    %   xmlfile: path to XML file containing classification labels.
%   OUTPUT:
    %   xdata: example data matrix size(examples, features)
    %   xlabels: vector with labels for each of the features in example
    %       size examples
    %   ydata: result data matrix size(examples, labels)
    %   ylabels: vector with labels for each of the labels in result data
    %       size labels

%% load the data from ARFF to matlab
wekaObj = loadARFF(arfffile);
[mdata,featureNames,targetNDX,stringVals,relationName] = weka2matlab(wekaObj, [])

% mdata has X and Y concatenated. We need to separate them.
%% Get the labels from XML file
DOMobject = parseXML(xmlfile);
labels = [];
for label = DOMobject.Children
    if ~isempty(label.Attributes)
        labels = [labels, string(label.Attributes.Value)];
    end
end    

idy = [];
%% Find indexes for Y labels
for label = labels
    id = find(strcmp(featureNames, label));
    if ~isempty(id)
        idy = [idy, id];
    end
end

%% Extract X and Y from mdata
ylabels = featureNames(idy);
ydata = mdata(:, idy);

xlabels = featureNames;
xlabels(idy) = [];
xdata = mdata;
xdata(:, idy) = [];

end

%% From https://www.mathworks.com/help/matlab/ref/xmlread.html
function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end
end


% ----- Local function PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   allocCell = cell(1, numChildNodes);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end
end

% ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Attributes', parseAttributes(theNode),  ...
   'Data', '',                              ...
   'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct.Data = '';
end
end

% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', ...
                       allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end
end