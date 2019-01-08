# fpTech
News tableview 

## Description

This demo app fetches news from following api:

https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=a8fabd9ff4234c82aad08eaaa4ea17a0&pageSize=5&page=1

* above api returns Json response
* **Codable** is used for handling Json
* Records are shown in **Table view** 
* News data is cached  page by page  using **Core data**.
* Images are cached using **NSCache**.
* Records are fetches by page number when user scroll down (as there may be lots of records)
* A detail page is also there which loads selected url (from the url button of tableview cell)in webview.


