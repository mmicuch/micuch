import * as Db from '../service/Database.js';
import express from 'express';
import * as ArticleRepository from '../repository/ArticleRepository.js';
import {authorize} from '../service/Security.js';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';
import { rename } from 'fs/promises';

// Pomocné funkcie
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Adresár kam sa budú ukladať súbory
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(__dirname, '../public/uploads/'));
    },
    filename: (req, file, cb) => {
        const articleId = req.body.id || 0;
        cb(null, `${articleId}.jpg`);
    }
});

const upload = multer({ storage: storage });

const router = express.Router();

router.use(express.urlencoded({ extended: true }));

/**
 * Zoznam článkov
 */
router.get("/", async (req, res) => {
    const sortBy = req.query.sortBy || 'event_date';
    let articles = await ArticleRepository.findAll(req.session.user, sortBy);

    res.render('article/index.html.njk', {
        articles: articles,
        sortBy: sortBy
    });
});

/**
 * Uložiť nový alebo upravený článok
 */
router.post("/edit/:articleId", authorize('admin'), upload.single('image'), async (req, res) => {
    let article = {
        id: parseInt(req.body.id, 10),
        title: req.body.title,
        content: req.body.content,
        eventType: req.body.eventType,
        eventDate: req.body.eventDate,
        location_id: req.body.locationId,
        isPrivate: req.body.isPrivate ? 1 : 0
    };

    let articleId = await ArticleService.saveArticle(article);

    // Ak sa jedná o nový článok, premenujem obrázok z 0.jpg na správne ID
    if (article.id === 0) {
        try {
            let oldName = path.join(__dirname, '../public/uploads/') + `0.jpg`;
            let newName = path.join(__dirname, '../public/uploads/') + `${articleId}.jpg`;

            await rename(oldName, newName); // vyvolá výnimku, ak súbor neexistuje.
        } catch {
            // Súbor neexistuje - nebol uploadnutý
        }
    }

    res.redirect('/article');
});

/**
 * Zobraziť formulár na úpravu alebo vytvorenie článku
 */
router.get("/edit/:articleId", authorize('admin'), async (req, res) => {
    let articleId = req.params.articleId;
    let article = await ArticleRepository.find(articleId);

    // Ak sa článok nenašiel, vytvoríme nový
    if (article === null) {
        article = {
            id: 0,
            title: '',
            content: '',
            eventType: '',
            eventDate: '',
            location_id: null,
            isPrivate: 0
        };
    }

    // Získame zoznam všetkých lokalít
    let locations = await Db.query("SELECT * FROM locations ORDER BY region, location");

    res.render('article/edit.html.njk', {
        article: article,
        locations: locations
    });
});

export { router as ArticleController }

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
        SELECT a.*, l.location, l.region 
        FROM articles a 
        JOIN locations l ON a.location_id = l.id 
    `;

    if (!user || !user.roles.includes('admin')) {
        query += `WHERE a.isPrivate = 0 `;
    }

    query += `ORDER BY ${orderBy}`;

    return await Db.query(query);
}

/**
 * Najst clanok podla ID
 */
async function find(articleId) {
    let result =  await Db.query(
        'SELECT a.*, l.location, l.region FROM articles a JOIN locations l ON a.location_id = l.id WHERE a.id=:articleId',
        { articleId: articleId }
    );

    return result.length > 0 ? result.pop() : null;
}

/**
 * Najst komentare podla ID clanku
 */
async function findComments(articleId) {
    return await Db.query(
        'SELECT * FROM comments WHERE article_id = :articleId ORDER BY created_at DESC',
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
 * Najst prvy clanok
 */
async function findFirst(user) {
    let query = `
        SELECT a.*, l.location, l.region 
        FROM articles a 
        JOIN locations l ON a.location_id = l.id 
    `;

    if (!user || !user.roles.includes('admin')) {
        query += `WHERE a.isPrivate = 0 `;
    }

    query += `LIMIT 1`;

    let articles = await Db.query(query);
    return articles.pop();
}

export {findAll, findFirst, find, findComments, deleteComment};