# Patent Explorer
R Shiny app for visualization of patent data
https://psim.shinyapps.io/patent/

## Global Patent Explorer (Beta Version V2.4)
Welcome to the AAU global patent explorer. This tool lets you map and visualize inventive and innovative activity around the globe. The explorer relies on a series of novel indicators that combine insights from large-scale natural language processing and established patent analysis techniques and provide insights about dimensions such as technological originality or future orientation. You can explore the dataset on country or city level, select time-ranges and technologies. The app features rich visualizations including a world map, network plots that show relations between countries and cities, and customizable statistical plots.

## Visualizations
**Map**: The map-view provides a geographical overview on inventive and innovative activity around the globe. It enables to visually compare patent activity either on global level across countries or within a country across cities.

**Network**: Uses the measures of technological distance based semantic similarity as constructed by Hain et al. (2018) (see below for further information) to explore similarities in patenting activity across countries and cities. In detail, it visualizes the overall technological similarity between countries or cities I and j, the similarity to past (similarity patents of i to previous patents of j), present (similarity patents of i to current patents of j), and future (similarity patents of i to later patents of j).

**Plots**: Provides informative figures on selected indicators, again across countries, or cities within countries. The first plot provides a bar chart of the selected indicators, while the second provides an interactive scatterplot, where the measures on the x- and y-axis can be individually chosen.

**Data**: Provides the selected data used to construct the visualizations. Since the patent explorer is still in beta version, the data is not available for download yet. However, you might for now request it at dsh@business.aau.dk .

## Indicators
The global patent explorers provides the possibility to analyze patents for selected countries, cities, and IPC (up to 3rd digit) classes. It currently visualizes the following indicators of technological novelty and potential impact and economic value. It draws from ex-ante (available in real time) as well as ex-post (available with delay after patent publication) indicators. Note that ex-post indicators are only available 5 years after patent publication, therefore stop at 2010. However, we currently work on providing predicted values for ex-post indicators in real time according to the methodology of Hain and Jurowetzki (2018) (see below for further information).

**Number of Patents**: The number of patents granted within the selection (time, geography, IPC class), derived from the PATSTAT data. Ex-ante indicator.

**Radicalness index**: Indicator aiming at measuring the technological radicalness of inventions. Operationalized as a time-invariant count of the number of IPC technology classes in which the patents cited by the given patent are, but in which the patent itself is not classified. For details, consider Squicciarini et al. (2013). Ex-ante indicator.

**Originality index**: The breadth of the technology fields on which a patent relies. For details, consider Squicciarini et al. (2013). Ex-ante indicator.

**Forward citations**: The number of citations a patent receives from later patents if often used as a measure of technological significance and impact. We here use the number of citations a patent receives in the 5 years following its publication. Ex-post indicator.

**Generality index**: Assess the range of later generations of inventions that have benefitted from a patent. Operationalized as the range of technology fields and consequently industries - that cite the patent. For details, consider Squicciarini et al. (2013). Ex-post indicator.

**(Semantic) Technological similarity**: Utilizes techniques from natural language processing (NLP) to construct measures of technological distance between patents based on the semantic similarity of the description of a patent's technological features in its abstract. Technological distance is also used to create patent-level measures of novelty (how similar is this patent to others published before), timeliness (how similar is the patent to others published around the same time) and impact (how similar is this patent to others published afterwards). For details consider Hain et al. (2018). Ex-ante (similarity to past, present) and ex-post (similarity to future) indicator.

**Breakthroughs**: The number of patents that are in the top 1% of received forward citations (5 years) within the corresponding category. For details, consider Squicciarini et al. (2013). Ex-post indicator.

## Data Sources
The global patent explorer aims at providing a comprehensive overview on patenting activity around the globe, in terms of patent quantity as well as quality. Therefore, it draws from the following sources:

### PATSTAT, Autumn 2017 version:

Provides basic information on patents granted by the EPO and USTPO, their inventors, and corresponding addresses which are used to determine their geographical location.

### OECD Patent Quality Indicators database, March 2018:

This database provides a number of indicators that are aimed at capturing the quality of patents, intended as the technological and economic value of patented inventions, and the possible impact that these might have on subsequent technological developments. It is available at: ftp://prese:Patents@ftp.oecd.org/Indicators_201803/

For further details consider: Squicciarini, M., H. Dernis and C. Criscuolo (2013), Measuring Patent Quality: Indicators of Technological and Economic Value, OECD Science, Technology and Industry Working Papers, No. 2013/03, available at: http://dx.doi.org/10.1787/5k4522wkw1r8-en

### AAU patent quality:

The AAU data on patent novelty and impact, based on semantic similarity. This data uses techniques from natural language processing (NLP) to construct measures of technological distance between patents based on the semantic similarity of the description of a patent's technological features in its abstract. Technological distance is also used to create patent-level measures of novelty (how similar is this patent to others published before) and impact (how similar is this patent to others published afterwards). For further details, consider:

D.S. Hain, R. Jurowetzki, T. Buchmann, P. Wolf (2018), A Vector Worth a Thousand Counts: A Temporal Semantic Similarity Approach to Patent Impact Prediction, available at: http://vbn.aau.dk/en/publications/a-vector-worth-a-thousand-counts(855d9758-d017-4b4a-baf5-8b7e72a1c223).html

## Feedback & Contact
All kinds of comments are highly appreciated to improve the quality of the global patent explorer. For feedback, requests, suggestions, bug- and error-reports (and everything else) contact
Daniel Hain, dsh@business.aau.dk

Further contributors to the project are:
- Roman Jurowetzki, roman@business.aau.dk
- Tobias Buchmann, tobias.buchmann@zsw-bw.de
- Patrick Wolf, patrick.wolf@zsw-bw.de

R Shiny app developed by
Paul Simmering, paul.simmering@gmail.com
