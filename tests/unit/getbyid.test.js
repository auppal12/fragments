const request = require('supertest');
const express = require('express');
const getById = require('../../src/routes/api/getbyid');
const { Fragment } = require('../../src/model/fragment');

jest.mock('../../src/model/fragment');

const app = express();
app.use(express.json());
app.get('/fragments/:id', (req, res) => getById(req, res));

describe('GET /fragments/:id', () => {
    it('should return a fragment if found', async () => {
        const mockFragment = { id: '123', ownerId: 'user1', type: 'text/plain', size: 10 };
        Fragment.byId.mockResolvedValue(mockFragment);

        const response = await request(app)
            .get('/fragments/123')
            .set('user', 'user1');

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('status', 'ok');
        expect(response.body).toHaveProperty('fragment');
        expect(response.body.fragment).toEqual(mockFragment);
    });

    it('should return 500 if an error occurs', async () => {
        Fragment.byId.mockRejectedValue(new Error('Fragment not found'));

        const response = await request(app)
            .get('/fragments/999')
            .set('user', 'user1');

        expect(response.status).toBe(500);
        expect(response.body).toHaveProperty('status', 'error');
        expect(response.body.error).toHaveProperty('message', 'Fragment not found');
    });
});
