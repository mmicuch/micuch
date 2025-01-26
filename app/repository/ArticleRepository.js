import * as Db from '../service/Database.js';

/**
 * Najst vsetky clanky
 */
async function findAll(user, sortBy = 'event_date') {
    let orderBy;
    switch (sortBy) {
        case 'title':
            orderBy = 'a.title';
            break;
        case 'region':
            orderBy = 'l.region';
            break;
        case 'event_date':
        default:
            orderBy = 'a.event_date';
            break;
    }

    let query = `
        SELECT a.*, l.location, l.region, ad.address AS address
        FROM articles a 
        JOIN locations l ON a.location_id = l.id 
        LEFT JOIN addresses ad ON l.id = ad.location_id
    `;

    if (!user || !user.roles.includes('admin')) {
        query += `WHERE a.isPrivate = 0 AND a.event_date >= CURDATE() `;
    }

    query += `ORDER BY ${orderBy}`;

    return await Db.query(query);
}

/**
 * Najst clanok podla ID
 */
async function find(articleId) {
    let result =  await Db.query(
        `SELECT a.*, l.location, l.region, ad.address AS address
         FROM articles a 
         JOIN locations l ON a.location_id = l.id 
         LEFT JOIN addresses ad ON l.id = ad.location_id 
         WHERE a.id=:articleId`,
        { articleId: articleId }
    );

    return result.length > 0 ? result.pop() : null;
}

/**
 * Najst komentare podla ID clanku
 */
async function findComments(articleId) {
    return await Db.query(
        'SELECT * FROM comments WHERE article_id = :articleId ORDER BY created_at ASC',
        { articleId: articleId }
    );
}

/**
 * Zmazat komentar podla ID
 */
async function deleteComment(commentId) {
    return await Db.query(
        'DELETE FROM comments WHERE id = :commentId',
        { commentId: commentId }
    );
}

/**
 * Zmazat clanok podla ID
 */
async function deleteArticle(articleId) {
    return await Db.query(
        'DELETE FROM articles WHERE id = :articleId',
        { articleId: articleId }
    );
}

/**
 * Najst prvy clanok
 */
async function findFirst(user) {
    let query = `
        SELECT a.*, l.location, l.region, ad.address 
        FROM articles a 
        JOIN locations l ON a.location_id = l.id 
        LEFT JOIN addresses ad ON l.id = ad.location_id
    `;

    if (!user || !user.roles.includes('admin')) {
        query += `WHERE a.isPrivate = 0 AND a.event_date >= CURDATE() `;
    }

    query += `LIMIT 1`;

    let articles = await Db.query(query);
    return articles.pop();
}

export {findAll, findFirst, find, findComments, deleteComment, deleteArticle};