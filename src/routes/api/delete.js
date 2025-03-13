
const { Fragment } = require('../../model/fragment');
const { createSuccessResponse, createErrorResponse } = require('../../response');
const logger = require('../../logger');

/**
 * Delete a fragment by ID
 */
module.exports = async (req, res) => {
    try {
        const { id } = req.params;
        const ownerId = req.user;

        logger.debug({ userId: ownerId, fragmentId: id }, 'Attempting to delete fragment');

        // First, check if the fragment exists
        try {
            await Fragment.byId(ownerId, id);
        } catch (error) {
            logger.warn({ error, userId: ownerId, fragmentId: id }, 'Fragment not found');
            return res.status(404).json(createErrorResponse(404, `Fragment not found: ${id}`));
        }

        // Delete the fragment
        await Fragment.delete(ownerId, id);

        logger.info({ userId: ownerId, fragmentId: id }, 'Fragment deleted successfully');

        res.status(200).json(createSuccessResponse());
    } catch (error) {
        logger.error({ error, userId: req.user, fragmentId: req.params.id }, 'Error deleting fragment');
        res.status(500).json(createErrorResponse(500, error.message));
    }
};