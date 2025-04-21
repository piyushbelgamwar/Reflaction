private ValidationErrorResponse performAsyncSchemaValidationStandard(InputStream inputStream, DataProcessingInfo dpInfo) {
    List<ValidationError> validationErrorsList = new ArrayList<>();

    // Get schema file specific to dataItem
    String dataItemWithVersion;
    if (dpInfo.getFilePath() == null) {
        dataItemWithVersion = dataItemVersionService.getDataItemVersionFromUrlPath(dpInfo);
    } else {
        dataItemWithVersion = dpInfo.getFilePath();
    }
    LOGGER.info("Data Item Version is {}", dataItemWithVersion);

    // Validate generated xml against dataItem specific schema / XSD and return validation errors, if any
    try {
        System.setProperty("javax.xml.transform.TransformerFactory",
                "com.saxonica.config.EnterpriseTransformerFactory");
        TransformerFactory transformerFactory = CommonUtility.getTransformerFactory();

        // ←─── ADD THIS TO PRESERVE WHITESPACE ───→
        transformerFactory.setAttribute(
            "http://saxon.sf.net/feature/strip-whitespace",
            "none"
        );

        String stringSchemaFile = dataItemVersionService
            .getStringFileNameByVersionAndExtension(dataItemWithVersion, schemaFileSuffix, dpInfo);
        LOGGER.info("stringSchemaFile = {}", stringSchemaFile);

        StreamSource specific = new StreamSource(
            getClass().getClassLoader().getResource(stringSchemaFile).toExternalForm()
        );
        ((EnterpriseTransformerFactory) transformerFactory).addSchema(specific);

        Transformer trans = transformerFactory.newTransformer();
        trans.setErrorListener(new SchemaErrorListener(validationErrorsList, dpInfo));

        StreamSource source = new StreamSource(inputStream);
        SAXResult sink = new SAXResult(new DefaultHandler());
        trans.transform(source, sink);

    } catch (Exception e) {
        LOGGER.error("Error Processing Schema Validation ", e);
        throw new SchemaValidationException("Error in schema validation", e);
    }

    if (!validationErrorsList.isEmpty()) {
        return new ValidationErrorResponse(validationErrorsList);
    }

    LOGGER.info("Schema level validation completed");
    return null;
}
