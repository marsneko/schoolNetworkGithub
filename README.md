# school network analyze


## install
1. Clone the files.
2. Download the row data from the google drive [link](https://drive.google.com/drive/folders/1rlI3qONQZOoSfIXWatK2-9yGQFD-Te_G?usp=share_link)
3. Move the downloaded files to rawData

## Analyze Part

### Files
- `pics`: Directory to save generated figures.
- `results`: Directory to save generated tables.
- `processedData`: Directory to save data processed by `tsneCluster.ipynb`.
- `rawData`: Directory to store raw data.

### Codes
- `tsneCluster.ipynb`: Uses t-SNE to cluster departments based on screening standards.
  - Input: Raw data.
  - Output: Processed data saved in the `processedData` directory.
- `competitionNetwork.ipynb`: Builds the competition network of departments.
  - Input: Raw data and processed data.
  - Output: Network analysis results.

## Crawling Part

### files
- `crossbystd` : save the crawled data by `crossbystudent.py`
- `cross` : save the crawled data by `getcrossdata.py`

### codes
- `crossbystudent.py` : crawls student data from the university list
  - saves university and student data in `crossbystd` directory
- `getcrossdata.py` : crawls university and sector data from the university list
  - saves university and sector data in `cross` directory

