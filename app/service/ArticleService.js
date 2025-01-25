import * as Db from '../service/Database.js';

/**
 * Uložiť článok do databázy
 * @param article
 */
async function saveArticle(article) {
    let result;

    if (article.id === 0) {
        // Nový článok
        result = await Db.query(`
            INSERT INTO articles (title, content, event_type, event_date, location_id, isPrivate) 
            VALUES (:title, :content, :eventType, :eventDate, :locationId, :isPrivate)`, {
            title: article.title,
            content: article.content,
            eventType: article.eventType,
            eventDate: article.eventDate,
            locationId: article.location_id !== null ? article.location_id : null,  // ✅ Oprava NaN
            isPrivate: article.isPrivate
        });
        article.id = result.insertId;
    } else {
        // Aktualizácia článku
        result = await Db.query(`
            UPDATE articles 
            SET title = :title, content = :content, event_type = :eventType, event_date = :eventDate, 
                location_id = :locationId, isPrivate = :isPrivate 
            WHERE id = :id`, {
            id: article.id,
            title: article.title,
            content: article.content,
            eventType: article.eventType,
            eventDate: article.eventDate,
            locationId: article.location_id !== null ? article.location_id : null,  // ✅ Oprava NaN
            isPrivate: article.isPrivate
        });
    }

    return article.id;
}

export { saveArticle };
