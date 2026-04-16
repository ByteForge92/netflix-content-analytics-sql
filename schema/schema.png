# 📊 Dataset Schema

The dataset contains information about Netflix movies and TV shows, including details such as title, genre, cast, and release year.

---

## 🧾 Table: netflix

| Column Name     | Data Type | Description |
|----------------|----------|------------|
| show_id        | VARCHAR  | Unique identifier for each title |
| type           | VARCHAR  | Type of content (Movie or TV Show) |
| title          | VARCHAR  | Name of the movie or TV show |
| director       | VARCHAR  | Director(s) of the content |
| cast           | TEXT     | List of actors (comma-separated) |
| country        | VARCHAR  | Country of production |
| date_added     | VARCHAR  | Date when content was added to Netflix |
| release_year   | INT      | Year the content was released |
| rating         | VARCHAR  | Content rating (e.g., TV-MA, PG) |
| duration       | VARCHAR  | Duration (minutes for movies, seasons for TV shows) |
| listed_in      | TEXT     | Genre/category (comma-separated) |
| description    | TEXT     | Brief summary of the content |

---

##Notes
- `date_added` is stored as a string and needs conversion using `STR_TO_DATE()`  
- `cast` and `listed_in` contain multiple values separated by commas  
- Some columns may contain NULL values (e.g., director, cast)  
