＃ school network analyze
## install
1. Clone the files.
2. Download the row data from the google drive link[https://drive.google.com/drive/folders/1rlI3qONQZOoSfIXWatK2-9yGQFD-Te_G?usp=share_link]
3. Move the downloaded files to rawData

## files 
- pics : save figures
- results : save tables
- processedData : save the data processed by tsneCluster.ipynb
- rawData : rawData

## codes
- tsneCluster : use tsne to cluster deparment by the screen standard
  - only need raw data as input. output the processData  
- competitionNetwork : build the competion network of departments
  - need raw data and processed data as input
