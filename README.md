# TMWYE-W
Tell me what you eat/watch, I tell you what to watch/eat

Renvois les infos d'un film = "https://api.themoviedb.org/3/movie/"+ imdb id "?api_key=72e58ed9123ba68d1f814768448360c0&language="+variable de langue

Liste par genre : https://api.themoviedb.org/3/genre/" + id du genre + "/movies?api_key=72e58ed9123ba68d1f814768448360c0&language=" + variable de langue (en, fr, en_EN, fr_FR) + "&include_adult=false&sort_by=created_at.asc"

Pour la recherche : https://api.themoviedb.org/3/search/movie?api_key=72e58ed9123ba68d1f814768448360c0&query=" + variable qui change +"&language=" + variable de langue

Liens vers image : "https://image.tmdb.org/t/p/w500" + liens vers renvoiyé par themovieDB poster
