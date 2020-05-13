%%
t = readtable('matlab_dataset.csv','TextType','string');

%%
text = t.content;

cleanedText = preprocessText(text);
bag = bagOfWords(cleanedText);
data = bag.Counts;
[m,n] = size(data);
%% Using Matlab Built In
tic
[coeff,score, latent, tsquared, explained] = pca(full(data),'NumComponents',2);
toc
explained = explained(1:10);
size(coeff);

 
%% Eigen Decomposition

centered_data = (data - mean(data))';

scaled_cov = (1/n) * (centered_data * centered_data');
%Since we have a sparse matrix, we are required to use this 
%function to find a subset of the eigenvectors and values
[W,EVs] = eigs(scaled_cov,2)
out = W'*centered_data;


%% SVD
tic
centered_data = (data - mean(data,'all'))';
scaled_data = centered_data / sqrt(n-1);

[U,S,Vt] = svds(scaled_data,2);

out = U'*centered_data;
size(U)
toc
%% Plotting

p = [score grp2idx(t.source)];

c_true = [zeros(200,1);ones(200,1);(ones(200,1)+1);ones(200,1)+2];
c_polar = [repmat("Liberal",400,1);repmat("Conservative",400,1)];
figure();
gscatter(p(:,1),p(:,2),t.source);
title("Sources by News Source");
%saveas(gcf,"news_sources.png");

figure();
gscatter(p(:,1),p(:,2),c_polar);
title("Sources by Political Leaning");
%saveas(gcf,"pol_leaning.png");


%This code comes directly from the matlab text analytics toolkit website.
function documents = preprocessText(textData)

% Tokenize the text.
documents = tokenizedDocument(textData);

% Remove a list of stop words then lemmatize the words. To improve
% lemmatization, first use addPartOfSpeechDetails.
documents = addPartOfSpeechDetails(documents);
documents = removeStopWords(documents);
documents = normalizeWords(documents,'Style','lemma');

% Erase punctuation.
documents = erasePunctuation(documents);

% Remove words with 2 or fewer characters, and words with 15 or more
% characters.
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,15);

end
