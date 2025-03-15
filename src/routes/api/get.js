const { createSuccessResponse, createErrorResponse } = require("../../response");
const { Fragment } = require('../../model/fragment');
const logger = require('../../logger');

/**
 * Get a list of fragments for the current user
 */
module.exports = async (req, res) => {
    try {
        // Check if we should expand the fragments or just return IDs
        const expand = req.query.expand === '1' || req.query.expand === 'true';
        
        logger.debug({ userId: req.user, expand }, 'Getting fragments for user');
        
        // Get all fragments for this user, passing the expand flag
        const fragments = await Fragment.byUser(req.user, expand);
        
        logger.debug({ 
            userId: req.user, 
            fragments: Array.isArray(fragments) ? fragments.length : 'unknown',
            expand 
        }, 'Got fragments');
        
        res.status(200).json({
            ...createSuccessResponse(),
            fragments,
        });
    } catch (error) {
        logger.error({ error, userId: req.user }, 'Unable to get fragments for user');
        res.status(500).json(
            createErrorResponse(500, error.message)
        );
    }
};
