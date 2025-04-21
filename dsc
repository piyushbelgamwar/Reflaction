import java.io.*;
import javax.xml.stream.*;

/**
 * XMLSpaceRemover - A utility for removing whitespace between XML tags
 * Designed to handle XML files up to 200MB efficiently
 * Input and output are both handled as InputStreams
 */
public class XMLSpaceRemover {

    private static final int BUFFER_SIZE = 8192;

    /**
     * Universal method to process XML by removing spaces between tags.
     * Takes an InputStream as input and returns an InputStream as output.
     *
     * @param inputStream the input XML as an InputStream
     * @return an InputStream containing the processed XML
     * @throws IOException if an I/O error occurs
     */
    public static InputStream processXML(InputStream inputStream) throws IOException {
        if (inputStream == null) {
            throw new IllegalArgumentException("Input stream cannot be null");
        }

        File tempOutputFile = File.createTempFile("processed_xml_", ".tmp");
        tempOutputFile.deleteOnExit();
        
        try (BufferedOutputStream outputStream = new BufferedOutputStream(
                new FileOutputStream(tempOutputFile), BUFFER_SIZE)) {
            
            // Process the XML using StAX parser
            processXmlStream(inputStream, outputStream);
        } catch (XMLStreamException e) {
            throw new IOException("Error processing XML stream", e);
        }
        
        // Return the processed content as an InputStream
        return new BufferedInputStream(new FileInputStream(tempOutputFile), BUFFER_SIZE);
    }

    /**
     * Process XML using StAX parser for memory efficiency.
     * 
     * @param input the input XML stream
     * @param output the output stream where processed XML will be written
     * @throws XMLStreamException if XML parsing error occurs
     * @throws IOException if I/O error occurs
     */
    private static void processXmlStream(InputStream input, OutputStream output) 
            throws XMLStreamException, IOException {
        
        // Configure XML input factory
        XMLInputFactory inputFactory = XMLInputFactory.newInstance();
        // Disable external entity resolution for security
        inputFactory.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, Boolean.FALSE);
        inputFactory.setProperty(XMLInputFactory.SUPPORT_DTD, Boolean.FALSE);
        
        // Create XML reader and writer
        XMLStreamReader reader = inputFactory.createXMLStreamReader(input);
        XMLOutputFactory outputFactory = XMLOutputFactory.newInstance();
        XMLStreamWriter writer = outputFactory.createXMLStreamWriter(output);
        
        // Variables to track state
        String currentElement = null;
        StringBuilder contentBuffer = new StringBuilder();
        boolean hasOnlyWhitespace = true;
        
        // Process XML events
        while (reader.hasNext()) {
            int event = reader.next();
            
            switch (event) {
                case XMLStreamConstants.START_DOCUMENT:
                    // Write XML declaration
                    writer.writeStartDocument(reader.getEncoding(), reader.getVersion());
                    break;
                    
                case XMLStreamConstants.END_DOCUMENT:
                    writer.writeEndDocument();
                    break;
                    
                case XMLStreamConstants.START_ELEMENT:
                    // If we were tracking content for a previous element, process it
                    if (currentElement != null && contentBuffer.length() > 0) {
                        // Only write content if it's not just whitespace
                        if (!hasOnlyWhitespace) {
                            writer.writeCharacters(contentBuffer.toString());
                        }
                        contentBuffer.setLength(0);
                        hasOnlyWhitespace = true;
                    }
                    
                    // Save current element name
                    currentElement = reader.getLocalName();
                    
                    // Write element start tag with prefix and namespace
                    writer.writeStartElement(reader.getPrefix(), reader.getLocalName(), 
                            reader.getNamespaceURI());
                    
                    // Write all namespace declarations
                    for (int i = 0; i < reader.getNamespaceCount(); i++) {
                        writer.writeNamespace(reader.getNamespacePrefix(i), 
                                reader.getNamespaceURI(i));
                    }
                    
                    // Write all attributes
                    for (int i = 0; i < reader.getAttributeCount(); i++) {
                        writer.writeAttribute(reader.getAttributePrefix(i),
                                reader.getAttributeNamespace(i),
                                reader.getAttributeLocalName(i),
                                reader.getAttributeValue(i));
                    }
                    break;
                    
                case XMLStreamConstants.END_ELEMENT:
                    // Handle any content before closing the element
                    if (currentElement != null && currentElement.equals(reader.getLocalName())) {
                        if (contentBuffer.length() > 0) {
                            // Only write content if it contains non-whitespace characters
                            if (!hasOnlyWhitespace) {
                                writer.writeCharacters(contentBuffer.toString());
                            }
                            contentBuffer.setLength(0);
                        }
                        hasOnlyWhitespace = true;
                    }
                    
                    // Write element end tag
                    writer.writeEndElement();
                    currentElement = null;
                    break;
                    
                case XMLStreamConstants.CHARACTERS:
                    if (currentElement != null) {
                        String text = reader.getText();
                        contentBuffer.append(text);
                        
                        // Check if content has non-whitespace characters
                        if (hasOnlyWhitespace && text.trim().length() > 0) {
                            hasOnlyWhitespace = false;
                        }
                    }
                    break;
                    
                case XMLStreamConstants.CDATA:
                    writer.writeCData(reader.getText());
                    break;
                    
                case XMLStreamConstants.COMMENT:
                    writer.writeComment(reader.getText());
                    break;
                    
                case XMLStreamConstants.PROCESSING_INSTRUCTION:
                    writer.writeProcessingInstruction(reader.getPITarget(), reader.getPIData());
                    break;
                    
                case XMLStreamConstants.DTD:
                    writer.writeDTD(reader.getText());
                    break;
                    
                case XMLStreamConstants.ENTITY_REFERENCE:
                    writer.writeEntityRef(reader.getLocalName());
                    break;
            }
        }
        
        writer.flush();
        writer.close();
        reader.close();
    }
    
    /**
     * Main method for command-line usage or testing.
     */
    public static void main(String[] args) {
        if (args.length == 2) {
            // Process file from command line arguments
            try {
                String inputFile = args[0];
                String outputFile = args[1];
                System.out.println("Processing XML file: " + inputFile);
                
                // Example of using FileInputStream directly as you mentioned
                FileInputStream fileInputStream = new FileInputStream(new File(inputFile));
                InputStream processedStream = processXML(fileInputStream);
                
                // Save processed output to file
                try (FileOutputStream fileOutputStream = new FileOutputStream(new File(outputFile))) {
                    byte[] buffer = new byte[BUFFER_SIZE];
                    int bytesRead;
                    while ((bytesRead = processedStream.read(buffer)) != -1) {
                        fileOutputStream.write(buffer, 0, bytesRead);
                    }
                }
                
                processedStream.close();
                System.out.println("Processing completed successfully. Output saved to: " + outputFile);
            } catch (IOException e) {
                System.err.println("Error processing XML file: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            // Example showing FileInputStream usage with a sample file
            try {
                System.out.println("Example usage with FileInputStream:");
                System.out.println("----------------------------------");
                
                // 1. Using FileInputStream as you described
                String xmlFilePath = "example.xml";
                System.out.println("Example code for your scenario:");
                System.out.println("File xmlFile = new File(\"" + xmlFilePath + "\");");
                System.out.println("FileInputStream fileInputStream = new FileInputStream(xmlFile);");
                System.out.println("InputStream processedXml = XMLSpaceRemover.processXML(fileInputStream);");
                System.out.println("// Now use processedXml as needed");
                
                // 2. Create an example XML file for demonstration
                String exampleXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                             "<root>\n" +
                             "  <BUID>  </BUID>\n" +
                             "  <Postcode>      </Postcode>\n" +
                             "  <Address>   </Address>\n" +
                             "  <test>content</test>\n" +
                             "</root>";
                
                // Write example file for testing
                File tempFile = File.createTempFile("example_", ".xml");
                tempFile.deleteOnExit();
                try (FileWriter writer = new FileWriter(tempFile)) {
                    writer.write(exampleXml);
                }
                
                // 3. Process the file using FileInputStream
                System.out.println("\nDemonstration with a temporary file:");
                FileInputStream fis = new FileInputStream(tempFile);
                InputStream processedStream = processXML(fis);
                
                // Print the result
                System.out.println("Processed XML:");
                BufferedReader reader = new BufferedReader(new InputStreamReader(processedStream));
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println(line);
                }
                
                reader.close();
                System.out.println("\nUsage: java XMLSpaceRemover <inputFile> <outputFile>");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
