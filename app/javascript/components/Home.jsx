import React, { useState, useEffect } from 'react';

function Home() {
    const [features, setFeatures] = useState([]);
    const [urls, setUrls] = useState([]);

    useEffect(() => {
        fetch('http://localhost:3000/api/features')
            .then(response => response.json())
            .then(data => {
                const featuresData = data.data.map(item => ({
                    id: item.id,
                    title: item.attributes.title,
                    magnitude: item.attributes.magnitude,
                    place: item.attributes.place,
                    time: new Date(item.attributes.time).toLocaleString(),
                    url: item.links.external_url
                }));
                setFeatures(featuresData);

                const urlsData = data.data.map(item => item.links.external_url);
                setUrls(urlsData);
            });
    }, []);

    return (
        <div>
            <h1>Lista de Features</h1>
            <table>
                <thead>
                    <tr>
                        <th>Título</th>
                        <th>Magnitud</th>
                        <th>Lugar</th>
                        <th>Fecha</th>
                        <th>URL Externa</th>
                    </tr>
                </thead>
                <tbody>
                    {features.map((feature, index) => (
                        <tr key={feature.id}>
                            <td>{feature.title}</td>
                            <td>{feature.magnitude}</td>
                            <td>{feature.place}</td>
                            <td>{feature.time}</td>
                            <td>
                                <button onClick={() => window.open(urls[index], '_blank')}>
                                    Ver más
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

export default Home;
