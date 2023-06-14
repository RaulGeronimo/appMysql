const express = require('express');
const router = express.Router();

const pool = require('../database');
const {
    isLoggedIn
} = require('../lib/auth');

router.get('/add', (req, res) => {
    res.render('contacts/add');
});

router.post('/add', async (req, res) => {
    const {
        fullname,
        phone,
        email,
        birth
    } = req.body;
    const newContact = {
        fullname,
        phone,
        email,
        birth,
        user_id: req.user.id
    };
    await pool.query('INSERT INTO contacts set ?', [newContact]);
    req.flash('success', 'Contacto guardado con éxito');
    res.redirect('/contacts');
});

router.get('/', isLoggedIn, async (req, res) => {
    const contacts = await pool.query('SELECT * FROM Vista_Usuarios WHERE user_id = ?', [req.user.id]);
    res.render('contacts/list', {
        contacts
    });
});

router.get('/delete/:id', async (req, res) => {
    const {
        id
    } = req.params;
    await pool.query('DELETE FROM contacts WHERE id = ?', [id]);
    req.flash('success', 'Contacto eliminado con éxito');
    res.redirect('/contacts');
});

router.get('/edit/:id', async (req, res) => {
    const {
        id
    } = req.params;
    const contacts = await pool.query('SELECT *, DATE_FORMAT(birth, \'%Y-%m-%d\') AS birth FROM contacts WHERE id = ?', [id]);
    console.log(contacts);
    res.render('contacts/edit', {
        contact: contacts[0]
    });
});

router.post('/edit/:id', async (req, res) => {
    const {
        id
    } = req.params;
    const {
        fullname,
        phone,
        email,
        birth
    } = req.body;
    const newContact = {
        fullname,
        phone,
        email,
        birth,
        user_id: req.user.id
    };
    await pool.query('UPDATE contacts set ? WHERE id = ?', [newContact, id]);
    req.flash('success', 'Contacto actualizado con éxito');
    res.redirect('/contacts');
});

module.exports = router;