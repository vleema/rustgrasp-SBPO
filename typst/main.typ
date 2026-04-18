#import "sbpo.typ": template
#import "@preview/algo:0.3.6": algo, i, d, comment, code

#show: template.with(
  title: "TíTULO DO ARTIGO",
  authors: (
    (
      name: "Primeiro Autor",
      institute: "Filiação",
      address: "Endereço da Instituição",
      email: "e-mail",
    ),
    (
      name: "Segundo Autor",
      institute: "Filiação",
      address: "Endereço da Instituição",
      email: "e-mail",
    ),
  ),
  resumo: [
    Este modelo resume as normas de formatação para os trabalhos completos a serem
    publicados nos Anais do LII SBPO. Título, filiação, resumo e palavras-chave
    devem repetir fielmente o que foi informado quando o autor cadastrou o artigo
    através do sistema de submissão. O Resumo deve ter no máximo 150 palavras.
  ],
  palchaves: [Primeira palavra-chave, Segunda palavra-chave, Última palavra-chave.],
  topicos-pt: [Tópicos (indique, em ordem de PRIORIDADE, o(s) tópicos(s) de seu artigo)],
  abstract-en: [
    This document presents the format for full papers to be published in the Annals
    of the LII SBPO. Title, affiliation, abstract and keywords must be exactly the
    same as the author informed when registered the paper through the submission
    system. The Abstract must not exceed 150 words.
  ],
  keywords-en: [First keyword. Second keyword. Last keyword.],
  topicos-en: [Paper topics (indicate in order of PRIORITY the paper topic(s))],
)

= Introdução

// Apresentar a categoria de problemas do PCV;
Com o avanço produtivo das sociedades ao decorrer das décadas, cada vez mais dados foram sendo coletados, aumentando a demanda pelo processamento em informações. Neste contexto, uma categoria de problemas que constantemente aparece pertencem à área da Otimização Combinatória. Tais problemas têm, para cada situação e conjunto de variáveis, um conjunto possível de soluções, onde o objetivo é encontrar a solução ótima para este cenário. Nesta categoria está o Problema do Caixeiro Viajante (PCV), uma classe de problemas que consiste em, dado um conjunto de cidades e uma matriz de distâncias entre elas, encontrar a rota com menor custo que atravesse todas as cidades uma única vez e retorne à cidade inicial #cite(<cervieri2000pcv>). 

// Discutir a complexidade desta categoria;
Dentre as especializações do PCV está o Problema do Roteamento de Veículos (PRV), onde o objetivo é determinar a "melhor rota" a ser traçada pelo motorista de um veículo qualquer. O critério de melhor rota é definido pelo próprio problema, podendo ser desde menor tempo a menor custo e outros. Entretanto, o PCV pertence à classe de problemas NP-difícil, não tendo solução em tempo polinomial: conforme variam a quantidade de variáveis (cidades, capacidade do veículo, custo de energia e outras restrições), a abordagem de procurar pela melhor solução de forma exaustiva mostra-se pouco eficiente.

// Mencionar (meta-)heurísticas como soluções pro PCV;

Como alternativas à abordagem exaustiva, foram desenvolvidas diversas heurísticas e metaheurísticas capazes de resolver esta classe de problemas. Este trabalho tem como objetivo estudar e avaliar a aplicação dos algoritmos Genético e Memético, estratégias já consagradas na literatura, a uma instância do problema do PRV, analisando as soluções encontradas em cada cenário do problema e seus desempenhos, bem como comparando com literaturas anteriores. O uso da linguagem de programação Rust também será abordado, explicando as vantagens de uso neste problema e detalhes de implementação que potencializam a eficiência dos algoritmos citados.

O cenário analisado no trabalho consiste na distribuição de laticínios por parte da Associação dos Pequenos Agropecuaristas do Sertão de Angicos (APASA): deve ser encontrada uma rota com origem em Angicos onde o veículo passe somente uma vez por cada cidade, buscando minimizar a distância da rota ou o tempo gasto. Com este estudo, será possível perceber tanto a utilidade de metaheurísticas na resolução de problemas computacionalmente difíceis quanto o uso da linguagem Rust como alternativa mais eficiente a implementações tradicionais.   

Assim, o presente artigo está dividido da seguinte forma: *COMPLETAR*

// Explicar o uso do Rust em comparação à literatura anterior;

/* refs
ref 2: CERVIERI, Alexandre; PY, Mónica – Algoritmo para a resolução do problema do caixeiro viajante [Em Linha]. Porto Alegre: Instituto de Informática - UFRGS, 2000. [Consult. 15 Abr. 2009]. Disponível em WWW: <URL:https://web.archive.org/web/20040926043051/http://www.inf.ufrgs.br/procpar/disc/cmp134/trabs/T2/001/mpisalesman/mpisalesman.pdf>
*/


/* 
A primeira página dos trabalhos publicados será constituída com as informações
fornecidas no formulário de submissão de trabalho. Por isto, os nomes de
*todos* os autores devem ser cadastrados nesse formulário. Os nomes que não
sejam informados nesse formulário não aparecerão entre os autores na programação
do Simpósio nem nos Anais.

No campo _Título do Artigo_ deve ser informado apenas o título do trabalho,
*sem qualquer identificação dos autores ou suas instituições*.

O campo _Resumo_ deverá ser preenchido com o Resumo, de *no máximo 150 palavras*,
seguido por 3 palavras-chave e pelo(s) nome(s) da(s) área(s) de classificação
principal do trabalho escolhida(s) entre aquelas assinaladas no campo _Tópicos_
(ordenadas em ordem de prioridade). A seguir, no caso de resumos escritos em
português ou espanhol, deverá vir o Abstract em inglês e as _keywords_,
traduzindo fielmente o Resumo e as palavras-chave.
*/

// = Submissão do Texto Completo
= Fundamentação Teórica

//TODO: SE PRECISAR DE MAIS REFS, ESSE TRABALHO TEM MUITA
// https://www.researchgate.net/publication/309729997_Metaheuristicas_Evolutivas_Aplicadas_ao_Problema_de_Roteamento_de_Veiculos_em_uma_Empresa_de_Laticinios_no_Interior_do_Rio_Grande_do_Norte_uma_Abordagem_Via_Algoritmos_Genetico_e_Memetico
== Problema do Caixeiro Viajante (PCV)
O PCV é um dos problemas mais clássicos da literatura. Este problema consiste em permitir que
um viajante (o "caixeiro") faça uma rota por $n$ cidades e retorne à cidade inicial, visitando
cada cidade uma única vez (add ref ?). É um resultado bem conhecido que o PCV é um problema NP-difícil (add ref 3), tornando o uso de algoritmos exatos uma estratégia ineficiente e de alto custo computacional para encontrar soluções para instâncias do problema. 

Como alternativas surgiram as metaheurísticas, algoritmos que proporcionam alta eficiência ao custo de não garantirem a solução ótima em todos os cenários. Além do menor tempo de processamento, outra vantagem das metaheurísticas é a flexibilidade, característica possível com o uso de hiperparâmetros, configurações que controlam como o algoritmo explora o espaço de busca. 

Dentre a miríade de métodos heurísticos utilizados, alguns dos mais comuns incluem: Colônia de Formigas [Dorigo e Stützle, 2004], Enxame de Partículas [Eberhart e Kennedy, 1995] e Algoritmos Genéticos [Holland, 1975]. 

== Algoritmo Genético
O Algoritmo Genético, proposto originalmente por [Holland, 1975], consiste em uma sequência de etapas que busca simular o processo de adaptação evolutiva das soluções a cada iteração de modo a aumentar as chances de encontrar a solução ótima. 

Neste sistema, uma população de indivíduos (denominados "cromossomos") é gerada de forma aleatória. Após isso, os indivíduos são avaliados de acordo com seu _fitness_, o custo total. Em seguida, ocorrem os surgimentos de novas gerações: a cada iteração certos indivíduos são selecionados para cruzarem e gerar descendentes; adicionalmente, estes e outros cromossomos podem ter mutações introduzidas, de modo a diversificar ainda mais as populações e evitar estagnação em soluções subótimas. Com os novos indivíduos a população inicial é renovada e cromossomos de maior _fitness_ são eliminados. Então, o algoritmo encerra se a condição de parada for atingida ou continua a produzir novas gerações até alcançar esta condição.

== Algoritmo Memético
O Algoritmo Memético, proposto originalmente por #cite(<moscato1989ma>), consiste em uma versão do Genético com a adição de uma Busca Local. Buscas Locais são heurísticas de melhoramento local que, dada uma solução candidata, produz um conjunto de soluções vizinhas com custo potencialmente menor. Existem diversos exemplos destas buscas, tais como _Swap_, _Shift_, _Or-Opt_ e _2-Opt_.

Ao combinar o uso tradicional do Algoritmo Genético com Buscas Locais esta metaheurística amplia a noção de evolução, validando tanto a evolução como espécie quanto a evolução pessoal de um único indivíduo. Assim, o Algoritmo Memético faz a exploração global e local dos cromossomos, podendo acelerar a descoberta da solução ótima.

/*
- DEF PCV
ref 3: https://dl.acm.org/doi/epdf/10.1145/290179.290180 (página 2, ela menciona Karp)
*/

= Metodologia
// Estudo de caso beeeeem simplificado: contextualizar um pouco, colocar tabela das cidades, explicar as 12 instâncias (6 de KM e 6 de Min) e dizer que mais detalhes tem no outro;
// Nosso algoritmo goated: 2 pseudocódigos (1 gen/mem + 1 trans) e detalhes de implementação do Rust

Nesta seção será detalhado o Problema do Roteamento de Veículos (PRV) aplicado à Associação dos Pequenos Agropecuaristas do Sertão de Angicos (APASA), os algoritmos utilizados e detalhes de implementação com a linguagem de programação Rust.

== Estudo de Caso: Distribuição de Produtos da APASA

Uma das operações presentes na APASA consiste na distribuição de laticínios através de um caminhão refrigerando, cujo trajeto tem como origem a cidade de Angicos e destinos como um conjunto de demais cidades do estado do Rio Grande do Norte. Neste problema existem 2 possíveis critérios para determinar a rota do veículo: 1) menor tempo e 2) menor distância total. Para a APASA, determinar a rota com menor tempo significa a minimizar também o custo com a refrigeração do veículo, enquanto calcular a rota com menor distância acaba por minimizar o uso de combustível.

Este é um cenário já bem presente na literatura conforme visto em estudos anteriores: estabelecido em #cite(<silva2012vrp>), foi resolvido utilizando o _solver_ GLPK para instâncias de 6 a 24 cidades; em #cite(<fernandes2016ag>), o número de cidades é ampliado para 48 e a quantidade total de instâncias para 12: 6 para calcular menor tempo e 6 para menor distância. Adicionalmente, o problema foi resolvido com o uso de algoritmos genéticos e meméticos; em #cite(<menezes2025>), a abordagem descrita consiste no uso de três variações do algoritmo GRASP. 

Para o cenário do presente estudo, serão utilizadas exatamente as mesmas instâncias definidas em #cite(<fernandes2016ag>). Para maiores detalhes acerca das cidades recomenda-se a consulta do artigo original.

#table(
  columns: (auto, auto, auto, 1fr),
  align: center,
  stroke: 0.5pt,
  table.header([*Instância*], [*Medida*], [*$n$*], [*Cidades pertencentes à instância (Nº - Quadro 1)*]
  ),
  underline[Problema 01], [Km], table.cell(rowspan: 2)[48],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
  40, 41, 42, 43, 44, 45, 46, 47 e 48],
  [Problema 02], [Min],

  // Problema 03 e 04
  [Problema 03], [Km], table.cell(rowspan:2)[36],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 e 36],
  [Problema 04], [Min],

  // Problema 05 e 06
  [Problema 05], [Km], table.cell(rowspan:2)[24],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23 e 24],
  [Problema 06], [Min],

  // Problema 07 e 08
  [Problema 07], [Km], table.cell(rowspan: 2)[12],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 e 12],
  [Problema 08], [Min],

  // Problema 09 e 10
  [Problema 09], [Km], table.cell(rowspan:2)[7],
  table.cell(rowspan:2)[1, 7, 8, 9, 10, 11 e 12],
  [Problema 10], [Min],

  // Problema 11 e 12
  [Problema 11], [Km], table.cell(rowspan:2)[6],
  table.cell(rowspan:2)[1, 2, 3, 4, 5 e 6],
  [Problema 12], [Min],
)

#align(center)[
  #text(size: 10pt)[Fonte: #cite(<fernandes2016ag>)]
]

== Implementação das metaheurísticas com Rust

Para resolver o problema descrito na subseção anterior foram realizadas implementações para as metaheurísticas dos Algoritmos Genético e Memético. Tais implementações serão descritas de foram conjunta, tendo em visto que o algoritmo memético, como visto anteriormente, requer como base fundacional o algoritmo genético.
A implementação foi realizada na linguagem Rust versão 1.85.0 com a utilização de matrizes de adjacência para representar os dados do problema em formato de grafo direcionado. 

O algoritmo abaixo ilustra o funcionamento e execução do algoritmo genético:
#algo(
  title: emph(smallcaps("Algoritmo_Genético")),
  parameters: ([#math.italic("n")],),
  comment-prefix: [#sym.triangle.stroked.r ],
  comment-styles: (fill: rgb(100%, 0%, 0%)),
  indent-size: 15pt,
  indent-guides: 1pt + gray,
  row-gutter: 5pt,
  column-gutter: 5pt,
  inset: 5pt,
  stroke: 2pt + black,
  fill: none,
  main-text-styles: (font: "New Computer Modern")
)[
  Define hiper-parâmetros \
  G ← Carregar dados iniciais \
  P ← Gerar população inicial a partir de G \
  while não atinge máximo de iterações do #i \
    Faz o cruzamento entre os indivíduos da população de P\
    Escolhe indivíduos para mutação \
    Renova população \
]\

Na linha 1, antes de inicializar o problema, ocorre a definição dos hiper-parâmetros. Tais variáveis determinam questões cruciais do algoritmo como a quantidade de gerações. Para a calibração foi utilizada a ferramenta _iRace_ #cite(<lopez2016irace>) com os seguintes parâmetros:
#table(
  columns: (1fr, auto, auto, auto),
  align: center,
  stroke: 0.5pt,
  table.header([*Tipo do Problema*], [*Nº iterações*], [*Tamanho da população*], [*Taxa de mutação*]),
  [Tempo(min)], [2452], [197], [0.0193],
  [Distância(km)], [677], [195], [0.0152]
)\
#align(center)[
  #text(size: 10pt)[Fonte: Autoria própria (2025)]
]

Na linha 2 ocorre o carregamento da instância. A inicialização deste grafo é feita de forma altamente eficiente através do uso de _procedural macros_, recurso do Rust que, neste cenário, carrega os dados da instância em tempo de compilação. Como o compilador conhece o grafo do problema ele é capaz de realizar otimizações mais agressivas, além de que nenhuma alocação foi feita na _heap_, somente na _stack_, tornando esta estratégia de inicialização dos dados importante para a velocidade do algoritmo. \

Na linha 3 ocorre a geração da população. A estratégia utilizada na solução foi inicializar um intervalo de 0 a $n$, onde $n$ é o número de nós (cidades) do problema e associar cada indivíduo a um número do intervalo de forma aleatória. \

Na linha 4 ocorre o loop principal do algoritmo. O número máximo de iterações é definido pelos hiper-parâmetros de cada execução. \

Na linha 5 ocorre o cruzamento dos indivíduos. A estratégia utilizada consistiu em dividir a população em 2 metades, realizar o crossover de cada elemento das duas metades e re-embaralhar o conjunto para permitir que diferentes indivíduos tenham a oportunidade de sofrer crossover. 

O Sequential Constructive Crossover (SCX) #cite(<ahmed2010ga>) foi utilizado para o crossover pois é considerado na literatura um dos melhores operadores #cite(<khan2015crossover>). A vantagem deste operador é manter características positivas dos pais enquanto descobre bons genes. 

A ideia deste crossover consiste em substituir um dos pais por um dos seus nós legítimos caso isso favoreça o _fitness_;
um nó legítimo é o primeiro nó visitado e que compõe a menor distância relativa ao nó atual, neste caso, o nó do pai analisado na iteração. É importante notar que o crossover não tem garantia de ser bem sucedido no algoritmo: caso um nó filho não tenha um fitness melhor que pelo menos um dos pais, ele não será aceito e a prole não será gerada.

Na linha 6 ocorre a mutação. A decisão tomada foi de que a mutação deve ocorrer somente em casos de crossover bem sucedidos. A ideia desta mutação é simples, consistindo em introduzir no indivíduo resultado da prole uma troca randômica entre 2 de seus nós sem se preocupar com o _fitness_ após isso.

Por fim, na linha 7 ocorre a renovação da população. Na implementação deste artigo, a renovação não ocorre de forma separada das outras etapas mas dentro do próprio cruzamento: ao substituir um dos indivíduos pais, o novo indivíduo garantidamente terá um menor _fitness_ que o anterior. Assim, cada geração terá um _fitness_ menor ou igual à anterior.

Adicionalmente, ao fim do processamento da geração é feita uma re-ordenação randômica dentro da população a fim de aumentar as chances de diversificação da prole na próxima geração. 

Quanto ao algoritmo memético, a principal distinção para o genético é a existência da busca local após a fase da mutação. O algoritmo abaixo ilustra o funcionamento dele:

#algo(
  title: emph(smallcaps("Algoritmo_Memético")),
  parameters: ([#math.italic("n")],),
  comment-prefix: [#sym.triangle.stroked.r ],
  comment-styles: (fill: rgb(100%, 0%, 0%)),
  indent-size: 15pt,
  indent-guides: 1pt + gray,
  row-gutter: 5pt,
  column-gutter: 5pt,
  inset: 5pt,
  stroke: 2pt + black,
  fill: none,
  main-text-styles: (font: "New Computer Modern")
)[
  Define hiper-parâmetros \
  G ← Carregar dados iniciais \
  P ← Gerar população inicial a partir de G \
  while não atinge máximo de iterações do #i \
    Faz o cruzamento entre os indivíduos da população de P\
    Escolhe indivíduos para mutação \
    Faz a busca local nos indivíduos pós-mutação \
    Renova população \
]\

Com a adição da etapa da busca local, a estratégia adotada consistiu em sortear um número no intervalo $[1, 100)$ e com base neste aplicar determinadas buscas locais no indivíduo. A divisão do intervalo consistiu em:
- Entre 1 a 24: aplica a busca local Shift;
- Entre 25 a 49: aplica a busca local Swap;
- Entre 50 a 74: aplica a busca local Two Opt;
- Entre 75 a 99: aplica a busca local Or Opt.
\

A relação entre as buscas locais e os intervalos em que acontecem foi pensada de forma aleatória e sem levar critérios determinísticos em consideração, pois o objetivo é gerar o máximo de soluções diversas dentro do possível. 

= Resultados
// Nosso algoritmo goated vs impl original 
// Tabela dos nossos 3 algoritmos, com mínimo, média e desvio padrão p cada um
// Tabela dos nossos 3 algoritmos comparando com literatura 2025
// Por que o nosso foi mais eficiente

= Conclusão 
// Sumarização do problema
// Sumarização da metodologia
// Sumarização dos resultados
// Próximos passos e possíveis melhorias



// = Instruções de Formatação

// Os trabalhos completos devem ter *no máximo 12 páginas*, sendo incluídos, neste
// limite: a primeira página com resumo; texto; tabelas; gráficos; agradecimentos;
// e referências.

// Os textos devem utilizar páginas de tamanho *A4* (29,7 x 21,0 cm) com
// *margem superior de 3,3 cm, inferior de 2,5 cm e laterais de 2,9 cm*. Devem ser
// escritos em coluna única, com fonte *_Times New Roman_ 11*.


//  = Estilo das Citações

// As citações de referências bibliográficas no texto devem utilizar colchetes. Elas
// devem conter os últimos sobrenomes dos autores, no caso de um ou dois autores, e
// o último sobrenome seguido de "et al.", no caso de mais de dois autores, seguidos
// do *ano da publicação*. Por exemplo: (i) para um e dois autores:
// #cite(<anna:06>), #cite(<smith:02>) e #cite(<machado>);
// (ii) para mais de dois autores: #cite(<silva:99>). Caso o nome do autor seja
// incorporado ao próprio texto como parte da frase, pode-se usar, por exemplo:
// (i) para um e dois autores: #cite(<anna:06>, form: "prose"),
// #cite(<pele:04>, form: "prose"), #cite(<web:16>, form: "prose") e
// #cite(<machado>, form: "prose");
// (ii) para mais de dois autores: #cite(<silva:99>, form: "prose"). As referências
// no final do texto devem estar em ordem alfabética do último sobrenome do primeiro
// autor.

#bibliography("refs.bib", style: "sbpo.csl", title: "Referências")
