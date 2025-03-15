const { Fragment } = require('../../model/fragment');
const { createErrorResponse } = require('../../response');
const logger = require('../../logger');

const md = require('markdown-it')();

/**
 * Get a fragment's data by its ID with optional format conversion based on extension
 */
module.exports = async (req, res) => {
    const userId = req.user;
    const { id, ext } = req.params;

    try {
        logger.info(`Fetching fragment by ID: ${id} with conversion to .${ext}`);

        // Get the fragment by ID
        const fragment = await Fragment.byId(userId, id);
        
        if (!fragment) {
            logger.warn(`Fragment not found for ID: ${id}`);
            return res.status(404).json(createErrorResponse(404, 'Fragment not found'));
        }

        try {
            // Get the data
            const data = await fragment.getData();
            
            // Handle conversion based on extension
            if (fragment.mimeType === 'text/markdown' && ext === 'html') {
                // Convert Markdown to HTML using markdown-it
                const htmlContent = md.render(data.toString());
                const htmlBuffer = Buffer.from(htmlContent);

                logger.debug({ htmlBuffer }, 'Converted Markdown to HTML');

                // Set appropriate headers for HTML content
                res.setHeader('Content-Type', 'text/html');
                res.setHeader('Content-Length', htmlBuffer.length);
                
                return res.status(200).send(htmlBuffer);
            }

            // For other supported formats or if we get here, return the original data
            res.setHeader('Content-Type', fragment.type);
            res.setHeader('Content-Length', fragment.size);
            return res.status(200).send(data);

        } catch (dataError) {
            logger.error(`Error retrieving fragment data with ID ${id}: ${dataError.message}`, { error: dataError });
            res.status(404).json(createErrorResponse(404, 'An error occurred while retrieving fragment data'));
        }
    } catch (error) {
        logger.error(`Error fetching fragment with ID ${id}: ${error.message}`, { error });

        if (error.message === 'Fragment not found') {
            return res.status(404).json(createErrorResponse(404, error.message));
        }

        res.status(500).json(createErrorResponse(500, 'An error occurred while fetching the fragment'));
    }
};